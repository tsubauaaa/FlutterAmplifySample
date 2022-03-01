# FlutterAmplifySample

## Configure the Amplify CLI

```
$ amplify configure
```

- とりあえずデフォルトで進める
- 権限は AdministratorAccess-Amplify のみ

## Flutter New Project

- vscode で Flutter: New Project 選択

## Install Amplify CLI Flutter Preview (Optional)

```
$ npm install -g @aws-amplify/cli@flutter-preview
```

## Amplify init

```
$ amplify init
Project information
| Name: flutterAmplifySample
| Environment: dev
| Default editor: Visual Studio Code
| App type: flutter
| Configuration file location: ./lib/
```

## Install amplify_flutter

- pubspec.yaml に amplify_flutter をインストールする

## Amplify Auth Add

```
$ amplify auth add
```

- configuration -> Default configuration
- sign in -> Username
- configure advanced settings: No, I'm done.

```
$ amplify push
```

## Install amplify_auth_cognito

- pubspec.yaml に amplify_auth_cognito をインストールする

## 仮パスワードなしの本番パスワードが有効な Cognito ユーザを作成する

### Cognito UserPool ID を調べる

```
$ aws cognito-idp list-user-pools --max-results 20 | jq ".UserPools[] | {Id, Name}"
```

### ユーザ作成する

```
$ aws cognito-idp admin-create-user \
--user-pool-id "ap-northeast-1_XXXXXXX" \
--username "example_user" \
--user-attributes Name=email,Value="example@example.com" Name=email_verified,Value=true \
--message-action SUPPRESS
```

- 作成したユーザの UserStatus が Force_CHANGE_PASSWORD なのでこの後、これを修正する

### ユーザのパスワードを設定する

```
$ aws cognito-idp admin-set-user-password \
--user-pool-id "ap-northeast-1_XXXXXX" \
--username "example_user" \
--password 'XXXXXXX' \
--permanent
```

## Amplify API の操作

### Amplify Api Add

```
$ amplify add api
```

- GraphQL
- authorization type -> Amazon Cognito User Pool
- Enable conflict detection -> Yes, it is a auto merge.
- schema template -> Single object with fields
- schema.graphql を編集する

### Amplify Api Update

```
$ amplify update api
```

- Enable conflict detection は add 時には Disable で add してその後、update 時に Auto Merge に update した
- authorization type は add 時には APIKey で add してその後、update 時に Amazon Cognito User Pool に update した

### Amplify Codegen models

```
$ amplify codegen models
```

### Amplify Push

```
$ amplify push
```

- ./lib/models に作成したスキーマのモデルクラスが作成される

## Install amplify_api / amplify_datastore

- pubspec.yaml に amplify_api と amplify_datastore をインストールする

## AWS Console からデータを graphql 登録するクエリを実行する

```
mutation addEvent {
  createEvent(
    input: {
      id: 1
      name: "イベント名"
      description: "イベント情報"
    }) {
    id
  }
}
```

AWS Console からのクエリだと Subscription がうまくいかなかったので注意
