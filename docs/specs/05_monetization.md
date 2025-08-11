# Specification: Monetization

This document outlines the monetization strategy for the "halfbaked" application, including subscription plans and payment integration.

## 1. Subscription Plans

There will be two primary subscription tiers: Free and Pro.

### 1.1. Free Plan

- **Cost:** $0
- **Features:**
  - Unlimited creation of public `ideas`.
  - A limit of **10** private `ideas`.
  - Unlimited creation of `plans`, `tasks`, and `documents` within allowed ideas.
  - Full access to core features like commenting, starring, and sharing.
- **Default:** All new users are automatically on the Free Plan.

### 1.2. Pro Plan

- **Cost:** $8 per month.
- **Features:**
  - Includes all features of the Free Plan.
  - Unlimited creation of private `ideas`.
  - Access to exclusive AI-powered tools:
    - Task Recommendations
    - Document Summarization
    - Document Completion

## 2. Upgrading and Downgrading

### 2.1. Upgrade Path (Free to Pro)
- Users can upgrade to the Pro Plan from their "Settings" or "Profile" page.
- The UI will clearly show the benefits of upgrading.
- When a user on a Free Plan attempts to create more than 10 private ideas, they will be prompted to upgrade.

### 2.2. Downgrade Path (Pro to Free)
- Users can cancel their Pro subscription at any time from their "Settings" page.
- The cancellation will take effect at the end of the current billing cycle. The user will retain Pro features until then.
- **Handling of Private Ideas:** If a user downgrades to the Free plan while having more than 10 private ideas, their oldest private ideas exceeding the limit will be automatically archived (made read-only). They will not be able to create new private ideas until they are below the 10-idea limit (either by deleting some or making them public). The UI must clearly communicate this to the user before they confirm the downgrade.

## 3. Payment Integration

- **Provider:** A third-party payment processor like Stripe or Braintree will be used to handle subscriptions and billing.
- **Process:**
  - When a user decides to upgrade, they will be redirected to a secure payment form hosted by the payment provider.
  - The application will use webhooks from the payment provider to manage subscription status (`active`, `canceled`, `past_due`, etc.).
  - The `profiles.subscription_plan` field will be updated based on these webhook events.

## 4. Billing Management

- Within their "Settings" page, Pro users will have a billing portal where they can:
  - View their current plan.
  - See their next billing date.
  - Update their payment method.
  - View their billing history and download invoices.
  - Cancel their subscription.
