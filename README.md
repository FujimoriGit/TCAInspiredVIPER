# TCAInspiredVIPER

このリポジトリは、従来のVIPERアーキテクチャにTCA(The Composable Architecture)の状態管理と副作用制御の考え方を取り入れたサンプルです。ビュー層では`Store`を介して状態を操作し、ビジネスロジックは`Interactor`にまとめ、副作用は`Effect`として抽象化します。

## なぜTCAInspiredVIPERなのか

一般的なVIPERではDI(依存性注入)の構造が複雑になりがちで、Presenterのロジックも肥大化しやすいという課題があります。本プロジェクトでは以下を目指しています。

- `Reducer`による一元的な状態管理
- 副作用を値として扱うことでテスト容易性を高める
- `AppDependency`から各`Context`へ依存を分配し、モック注入を容易にする

## VIPERとの違い

| 層 | 役割 |
| --- | --- |
| **Feature** | Presenter 相当。`Reducer`としてActionからStateとEffectを生成 |
| **Interactor** | ドメイン処理を担う純粋関数群。副作用は`Effect`生成メソッドとして提供 |
| **Effect** | API呼び出しや画面遷移など非同期タスクを表す値 |
| **Context** | `AppDependency`を基にした各Feature用依存注入構造体 |
