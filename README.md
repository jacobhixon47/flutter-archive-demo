# Flutter Archive Demo

A demo of accordion functionality with GraphQL implementation.

_This project uses [Envied](https://pub.dev/packages/envied) for secure environment variable generation and storage._

1. Run `$ flutter pub get`

2. Create an `.env` file in the root directory of the project

3. Store your API URL in a variable called `API_LINK`

4. Run `$ dart run build_runner build -d`

_Note: Any time you add an env variable, you need to update env.dart to reflect it, and then rerun the above command_

_A [Hygraph](https://hygraph.com) GraphQL API was used in development._
