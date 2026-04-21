# Vercel Backend — RailAlert FCM Notifications

This folder contains the free Vercel serverless backend that sends FCM push notifications
to the `gate-status-alerts` topic whenever the gate status changes.

## Why Vercel?
Firebase Cloud Functions require the Blaze (pay-as-you-go) plan.
Vercel's free Hobby tier handles this workload at zero cost.

## Folder Structure
```
vercel_backend/
├── api/
│   └── notify.js      ← The single serverless endpoint (POST /api/notify)
├── package.json       ← Node.js dependencies (firebase-admin)
└── README.md          ← This file
```

## Environment Variables (set in Vercel Dashboard → Project → Settings → Environment Variables)

| Variable | Description |
|---|---|
| `FIREBASE_SERVICE_ACCOUNT` | The **entire** Firebase service account JSON as a single-line string |
| `NOTIFY_SECRET_KEY` | A strong random secret string (matches `AppConstants.notifySecretKey` in Flutter) |

### How to get the Service Account JSON
1. Firebase Console → Project Settings → Service Accounts
2. Click "Generate new private key" → Download JSON file
3. Open the file, copy **everything**, paste as the value (Vercel handles multi-line)

## API Specification

**Endpoint:** `POST /api/notify`

**Request body (JSON):**
```json
{
  "newStatus": "ALERT",
  "secret_key": "your-secret-key-here"
}
```
`newStatus` must be one of: `OPEN`, `ALERT`, `CLOSED`

**Success response:**
```json
{ "success": true, "status": "ALERT", "messageId": "projects/.../messages/..." }
```

**Error responses:**
- `403` — wrong secret_key
- `400` — invalid/missing newStatus
- `405` — non-POST method
- `500` — FCM send failed

## Deployment
1. `cd vercel_backend`
2. `vercel deploy --prod`
   (or push to a GitHub repo and connect to Vercel for auto-deploys)
