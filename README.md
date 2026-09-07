# M-PESA Mini App

A small Flutter app built for the Safaricom Ethiopia practical test. Three screens:
a splash, a 4-digit PIN sign-in, and an account home for the signed-in user.

The PIN is `1111`. Anything else gets rejected by the API.

## How to run

```sh
flutter pub get
flutter run
```

It runs on any target. `flutter run -d chrome` is the quickest if you just want to
look at it.

```sh
flutter analyze     # clean
```

Developed on Flutter 3.38.5 / Dart 3.10.4. Nothing to configure first: the endpoint is
public, so there's no `.env`, no key, no platform setup.

## Architecture

```
lib/
  core/        theme, router, dio client, formatters, shared widgets
  data/        models, datasources, repositories
  features/
    splash/    presentation
    auth/      application (state + controllers) | presentation
    home/      application | presentation
```

Feature-first, with a shared `core/` underneath. I picked this over grouping by type
(all screens together, all models together) because features are how the app actually
changes. Adding "send money" later means adding one folder, not touching five.

Dependencies only point inward. A screen calls a controller, a controller calls a
repository, a repository calls a datasource. Nothing calls back up.

The line I care most about is inside `data/`. `AuthRemoteDataSource` deals with HTTP and
nothing else: it makes the Dio call and converts transport problems into typed failures,
then hands back the decoded JSON as-is. `AuthRepository` decides what that JSON *means*
and builds the models. So when this mock gets swapped for the real gateway, the
datasource is the only file that changes.

Controllers live in `features/*/application`. That's why the PIN lockout rule is a plain
class I can unit test instead of logic buried in a widget. The widgets stay thin: they
read state and call methods.

## Packages

`flutter_riverpod` for state and dependency injection. `AsyncValue` already models
loading/data/error, which is exactly the shape of a sign-in request, and provider
overrides are what let the tests inject a fake repository without a mocking library.

`go_router` for navigation. The auth guard is a single `redirect` rule rather than
`Navigator` calls sprinkled around the app.

`dio` for HTTP. Timeouts, interceptors and a typed `DioException` I can pattern-match on.
With `package:http` I'd be writing that myself.

`iconsax_flutter` for icons, and `intl` for ETB amounts and dates.

I wrote the Riverpod providers by hand instead of adding `riverpod_generator`. Codegen
saves a bit of typing and costs a `build_runner` step that anyone opening this repo has
to run. For an app this size that trade isn't worth it.

Note on IconSax: the task asks for it, but the `iconsax` package on pub.dev is capped at
Dart `<3.0.0` and won't resolve here. `iconsax_flutter` is the maintained port with the
same `Iconsax.*` API, so that's what I used.

Similarly, go_router is pinned to 17.5.0 rather than 18, which requires Dart 3.12.

## Technical decisions

**Treating a wrong PIN as an answer, not an error.** The API returns 404 when the PIN is
wrong. I set `validateStatus: status < 500` on the Dio client so that 404 comes back as a
normal response, and `AuthRepository` classifies it next to every other outcome. The
alternative is pulling it out of a catch block, which splits one decision across two
places. Real network faults still throw and get mapped to `NetworkFailure`.

**Not showing the API's 404 text.** The mock replies with `USER_NOT_FOUND` and the detail
"No user was found with the provided phone number". No phone number is ever sent, only a
PIN, so that message would tell the customer something false about their account. It maps
to "Incorrect PIN. Please try again."

**Only a wrong PIN counts toward the lockout.** Three rejections locks the keypad for 30
seconds. A dropped connection doesn't cost an attempt, since it isn't the customer's
fault. There's a test for this because it's easy to get wrong.

**Sealed failure types.** `ApiException` has four subtypes and each one carries a message
that's safe to put on screen. Nothing in the UI reads status codes or assembles error
strings.

**No session persistence.** Nothing in the brief asks for it, and secure storage means
per-platform setup. The session lives in memory, so a restart takes you back to sign-in,
which is reasonable behaviour for a wallet. The API returns `expiresIn: 3600` but has no
refresh endpoint; I keep the value on `AuthSession` and would schedule re-auth against it
in a real build.

**A custom keypad instead of a `TextField`.** Banking apps don't raise the system keyboard
for a PIN. Doing it manually also means the digits, the backspace and the disabled state
all sit under one controller, so locking out the user disables input for free.

**Phone-first, but it doesn't fall apart elsewhere.** On a wide window the content is
centred at 460px instead of stretching a keypad across a desktop, and the sign-in screen
scrolls rather than clipping its bottom row on a short screen. I checked both at 320x568
and 390x844, which is how I found the two overflows that used to be there.

## What's real and what isn't

Name, phone number, balance and currency come from the API. There's only a login
endpoint, so a few things on Home are local:

- Recent activity is a fixture behind `recentTransactionsProvider`. Pointing it at a real
  repository is a one-line change and no widget moves.
- Reward on the balance card is hardcoded, since the API has no such field.

I'd rather say this outright than have it look like live data.

## AI tools used

I used Chat gpt and Claude.

Before writing any models I had it call the endpoint with a good and a bad PIN and print
both raw payloads. That's how I knew `id` is a string, and how I spotted the phone-number
wording in the 404 that ended up shaping the error handling.

It drafted the repetitive layers — theme tokens, formatters, the first pass at the card
and keypad widgets — which I then edited. The first version of the balance card used
`findAncestorStateOfType` to reach the holder name; I replaced that with a parameter.

I also used it to check my Riverpod, since 3.0 unified `Ref` and removed
`AutoDisposeNotifier`, and I'd rather read the current API than trust my memory of it.

The most useful thing was catching my own mistakes. I had it run the built app in a
browser and check the layout at different screen sizes, which turned up the desktop
stretching, a sub-pixel overflow on the activity header, and a clipped keypad row at
320pt. None of those show up in `flutter analyze`.

What I didn't do is ship code I hadn't read. The architecture, the error-handling policy
and the lockout rule are my decisions, and every file here has been through my hands.
