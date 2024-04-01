# API Sandbox

## Introduction

API Sandbox that returns bank account and transaction data mimicking the same schema as that in production.

## Description

The application responds to the following routes:

```
GET /accounts
GET /accounts/:account_id
GET /accounts/:account_id/details
GET /accounts/:account_id/balances
GET /accounts/:account_id/transactions
GET /accounts/:account_id/transactions/:transaction_id
```

### Authentication

- The application requires authentication using an API token supplied using HTTP Basic Auth in the username field. The password field is left empty. Token is an opaque, URL safe string with a prefix of "test\_".

- Given the same API token the application returns the same data each time a request is made, meaning the same account(s) with exactly the same account information, and exactly the same feed of transactions, even after application restarts.

### Usage

- The transactions endpoint returns a list of transactions going back 10 days. It returns 1 transaction per day.

- Each transaction has the type "card_payment", a description of the merchants, and a negative amount (money debited from the account).

- Each transaction has a running balance (sum of transactions up to the given transaction applied to the opening balance).

- The links in the JSON responses map to the application's base URL.

- The application does not use a database/genserver/agent/file system or any persistence. It is completely stateless and all data must is procedurally generated/chosen.

## Install

To install your dependencies:

- Install dependencies with `mix deps.get`

## Run

To run your Phoenix server:

- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Log in into the app with the following credentials: **user_XXXXX** (5 X's), where X is a digit.
Use **user_multiple_XXXXX** for user with multiple accounts. Password empty.

## Tests

To run the tests:

- `mix test`
