# Org Fair

Live URL: https://frostymaverixk.github.io/Assignment-8/

Flutter app for the CICT Org Fair. Event listings are configured to load from
Contentful's Content Delivery API.

## Deployment workflow

This project is configured for GitHub Pages deployment through GitHub Actions.
In the GitHub repository, open **Settings > Pages** and select **GitHub Actions**
as the source. Under **Settings > Secrets and variables > Actions**, add:

| Kind | Name | Value |
|---|---|---|
| Repository variable | `CMS` | `contentful` |
| Repository variable | `CMS_SPACE` | Your Contentful space ID |
| Repository secret | `CMS_TOKEN` | Your Content Delivery API access token |

Push to `main`, or run **Deploy to GitHub Pages** manually from the Actions tab.
The deployment checks the Contentful settings, runs tests, builds the web app,
and publishes it. Missing CMS settings stop deployment with an error.
CI checks pull requests and pushes. Both workflows use Flutter 3.47.7.

## Configure Contentful

Create a Contentful content type with the ID `fairevent` and these fields:

| Field | Contentful type |
|---|---|
| `title` | Short text |
| `orgId` | Short text |
| `startsAt` | Date and time |
| `venue` | Short text |
| `description` | Long text |
| `cancelled` | Boolean |

Publish the event entries, then create an API key and use its **Content Delivery
API access token**. Do not use a Content Management token in the app.

Copy `cms.example.json` to the ignored `cms.json`, then replace its placeholders
with your Contentful space ID and delivery token:

```json
{
  "CMS": "contentful",
  "CMS_SPACE": "your-space-id",
  "CMS_TOKEN": "your-delivery-token"
}
```

The local `cms.json` is ignored by Git. Keep your delivery token there and do
not commit it. The Content Delivery API only returns published entries.

## Run and test

```powershell
flutter pub get
flutter run --dart-define-from-file=cms.json
flutter test
flutter analyze
```

Without `cms.json` defines, the app uses built-in sample events. Contentful
returns published entries; drafts are not available through the Content
Delivery API.

The delivery token is included in the compiled app, even when GitHub stores it
as a secret. Use a read-only Content Delivery token and keep management tokens
out of the app.
