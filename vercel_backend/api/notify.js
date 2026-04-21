// api/notify.js
// RailAlert — Vercel Serverless FCM Notification Handler
// Triggered by GateService after a successful Firebase RTDB write.
// Uses firebase-admin initialized via environment variables (no hardcoded secrets).

const admin = require('firebase-admin');

// ── Firebase Admin Initialization ────────────────────────────────────────────
// Initialize only once (Vercel may reuse the same Node.js runtime across calls).
if (!admin.apps.length) {
  // FIREBASE_SERVICE_ACCOUNT must be set in Vercel Environment Variables.
  // Its value is the *entire* service-account JSON stringified into one line.
  // e.g.:  {"type":"service_account","project_id":"...","private_key":"..."}
  let serviceAccount;
  try {
    serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  } catch (e) {
    console.error('[RailAlert] Failed to parse FIREBASE_SERVICE_ACCOUNT:', e.message);
    // Do not throw here — allow the function to boot; the error surfaces per-request.
  }

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

// ── Notification payload registry ────────────────────────────────────────────
const NOTIFICATIONS = {
  ALERT: {
    title: '⚠️ Train Coming — Gates Closing Soon',
    body: 'A train is approaching the Raiwala Fatak. Please clear the crossing.',
  },
  CLOSED: {
    title: '🚧 Gates Closed',
    body: 'The Raiwala Fatak gates are now closed. Please wait.',
  },
  OPEN: {
    title: '✅ Gates Open — Safe to Cross',
    body: 'The Raiwala Fatak gates are now open. Have a safe journey!',
  },
};

// ── FCM topic ─────────────────────────────────────────────────────────────────
const FCM_TOPIC = 'gate-status-alerts';

// ── Handler ───────────────────────────────────────────────────────────────────
module.exports = async function handler(req, res) {
  // Only accept POST
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed. Use POST.' });
  }

  const { newStatus, secret_key } = req.body;

  // ── Security check ────────────────────────────────────────────────────────
  const expectedSecret = process.env.NOTIFY_SECRET_KEY;
  if (!expectedSecret || secret_key !== expectedSecret) {
    console.warn('[RailAlert] Rejected request — invalid secret_key');
    return res.status(403).json({ error: 'Forbidden: invalid secret_key.' });
  }

  // ── Input validation ──────────────────────────────────────────────────────
  const validStatuses = Object.keys(NOTIFICATIONS);
  if (!newStatus || !validStatuses.includes(newStatus)) {
    return res.status(400).json({
      error: `Invalid or missing newStatus. Expected one of: ${validStatuses.join(', ')}.`,
    });
  }

  const { title, body } = NOTIFICATIONS[newStatus];

  // ── Send FCM message to topic ─────────────────────────────────────────────
  const message = {
    notification: { title, body },
    topic: FCM_TOPIC,
    android: {
      priority: 'high',
      notification: {
        sound: 'train_horn',
        channelId: 'gate_status_channel',
      },
    },
  };

  try {
    const messageId = await admin.messaging().send(message);
    console.log(`[RailAlert] FCM sent for status=${newStatus}, messageId=${messageId}`);
    return res.status(200).json({
      success: true,
      status: newStatus,
      messageId,
    });
  } catch (error) {
    console.error('[RailAlert] FCM send failed:', error.message);
    return res.status(500).json({
      error: 'FCM send failed.',
      details: error.message,
    });
  }
};
