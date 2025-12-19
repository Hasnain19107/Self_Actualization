# PayPal Configuration Guide

This guide will help you set up PayPal payments for your Self Actualization app.

## Prerequisites

- A PayPal Business account (or Personal account with business features)
- Access to PayPal Developer Dashboard

## Step 1: Create a PayPal Developer Account

1. Go to [https://developer.paypal.com/](https://developer.paypal.com/)
2. Click **"Log In"** and sign in with your PayPal account
3. If you don't have a PayPal account, create one first at [https://www.paypal.com/](https://www.paypal.com/)

## Step 2: Create a PayPal App

1. Once logged in, navigate to **Dashboard** → **My Apps & Credentials**
2. You'll see two sections:
   - **Sandbox** (for testing)
   - **Live** (for production)

### For Testing (Sandbox):

1. Under **Sandbox** section, click **"Create App"**
2. Fill in the app details:
   - **App Name**: Self Actualization (or any name you prefer)
   - **Merchant**: Select your sandbox business account
3. Click **"Create App"**
4. You'll see your credentials:
   - **Client ID**
   - **Secret Key**
5. **Copy these credentials** - you'll need them for the `.env` file

### For Production (Live):

1. Under **Live** section, click **"Create App"**
2. Fill in the app details:
   - **App Name**: Self Actualization Production
   - **Merchant**: Select your live business account
3. Click **"Create App"**
4. Copy the **Client ID** and **Secret Key**

## Step 3: Configure Your .env File

1. Open the `.env` file in the root of your project
2. Replace the placeholder values with your actual credentials:

```env
# For Sandbox (Testing)
PAYPAL_CLIENT_ID=your_sandbox_client_id_here
PAYPAL_SECRET_KEY=your_sandbox_secret_key_here
PAYPAL_SANDBOX_MODE=true

# For Production (Live)
# PAYPAL_CLIENT_ID=your_live_client_id_here
# PAYPAL_SECRET_KEY=your_live_secret_key_here
# PAYPAL_SANDBOX_MODE=false
```

## Step 4: iOS Configuration

✅ **iOS Configuration is already set up!**

The following iOS configurations have been added to `ios/Runner/Info.plist`:

1. **LSApplicationQueriesSchemes**: Allows the app to check if PayPal app is installed
2. **CFBundleURLTypes**: Handles PayPal redirects back to your app
3. **NSAppTransportSecurity**: Allows secure connections to PayPal domains

These settings enable:
- PayPal app integration (if installed)
- Secure payment redirects
- Web-based PayPal checkout

No additional iOS configuration is needed! ✅

## Step 5: Test Your Configuration

### Testing with Sandbox:

1. Make sure `PAYPAL_SANDBOX_MODE=true` in your `.env` file
2. Use PayPal sandbox test accounts:
   - Go to **Dashboard** → **Accounts** (under Sandbox)
   - Create test accounts or use the default ones
   - Use these accounts to test payments in your app

### Test Accounts:

PayPal provides default sandbox accounts:
- **Buyer Account**: `buyer@personal.example.com`
- **Seller Account**: `seller@business.example.com`

You can also create custom test accounts in the PayPal Developer Dashboard.

## Step 6: Production Setup

⚠️ **Important**: Only switch to production after thorough testing!

1. Get your **Live** credentials from PayPal Developer Dashboard
2. Update your `.env` file:
   ```env
   PAYPAL_CLIENT_ID=your_live_client_id
   PAYPAL_SECRET_KEY=your_live_secret_key
   PAYPAL_SANDBOX_MODE=false
   ```
3. Test with a small amount first
4. Monitor transactions in PayPal Dashboard

## Current App Configuration

Your app is configured to:
- Accept payments in **AUD (Australian Dollars)**
- Process subscriptions for:
  - Premium Plan: A$19
  - Coach Plan: A$39
- Handle payment success, error, and cancellation callbacks

## Troubleshooting

### Common Issues:

1. **"Invalid Client ID" Error**
   - Verify your Client ID is correct
   - Make sure you're using the right credentials (sandbox vs live)
   - Check that the app is active in PayPal Dashboard

2. **"Invalid Secret Key" Error**
   - Verify your Secret Key is correct
   - Secret keys are case-sensitive
   - Make sure there are no extra spaces

3. **Payments Not Processing**
   - Check your internet connection
   - Verify PayPal API is accessible
   - Check app logs for detailed error messages

4. **Sandbox Mode Not Working**
   - Ensure `PAYPAL_SANDBOX_MODE=true` (lowercase)
   - Use sandbox test accounts
   - Check that sandbox app is created in PayPal Dashboard

## Security Best Practices

1. **Never commit `.env` file to version control**
   - The `.env` file is already in `.gitignore`
   - Keep your credentials secure

2. **Use different credentials for development and production**
   - Never use live credentials for testing
   - Rotate credentials if compromised

3. **Monitor your PayPal account regularly**
   - Check for unauthorized transactions
   - Set up PayPal notifications

## Additional Resources

- [PayPal Developer Documentation](https://developer.paypal.com/docs/)
- [PayPal REST API Reference](https://developer.paypal.com/docs/api/overview/)
- [PayPal Sandbox Testing Guide](https://developer.paypal.com/docs/api-basics/sandbox/)

## Support

If you encounter issues:
1. Check PayPal Developer Dashboard for API status
2. Review app logs for detailed error messages
3. Consult PayPal Developer Documentation
4. Contact PayPal Developer Support if needed

