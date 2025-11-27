# ECS Fargate Application CI/CD with GitHub Actions

本リポジトリは、GitHub Actions を用いて  
Amazon ECS Fargate へ Web アプリケーションを自動デプロイする CI/CD パイプラインの実装例です。

Docker イメージのビルドから Amazon ECR への Push、ECS サービスの更新までを  
完全に自動化しており、実務運用を想定した構成となっています。

インフラ構築は Terraform で別リポジトリにて管理し、  
本リポジトリではアプリケーションデプロイ専用の CI/CD を担当します。

---

## 構成概要

- コンテナ実行基盤：Amazon ECS Fargate
- コンテナレジストリ：Amazon ECR
- CI/CD：GitHub Actions
- 認証方式：OIDC（AssumeRole による一時認証）
- ログ管理：CloudWatch Logs
- デプロイ方式：強制ローリングデプロイ（force-new-deployment）

---

## CI/CD フロー

main ブランチへの push をトリガーに、以下の処理が自動実行されます。

1. GitHub リポジトリのソースコードを checkout
2. OIDC により AWS IAM Role を Assume
3. Amazon ECR にログイン
4. Docker イメージをビルド
5. Amazon ECR へイメージを Push
6. ECS タスク定義を GitHub Actions 上で動的生成（JSON）
7. ECS タスク定義を登録
8. ECS サービスを更新し、新しいタスクをデプロイ

---

## セキュリティ設計

- OIDC + AssumeRole による一時認証を採用
- AWS アクセスキーは GitHub Secrets に保存しない設計
- IAM Role は最小権限で設計
  - ECR Push
  - ECS タスク定義登録
  - ECS サービス更新

長期的な認証情報を保持しないセキュアな CI/CD を実現しています。

---

## 使用している GitHub Actions Workflow（概要）

- main ブランチ push をトリガーに自動デプロイ
- OIDC による AWS 認証
- Docker Build → ECR Push → ECS Deploy を自動実行
- タスク定義は jq により動的生成

---

## ECS タスク定義の設定内容（抜粋）

- 起動タイプ：FARGATE
- ネットワークモード：awsvpc
- CPU：256
- メモリ：512
- コンテナポート：80
- CloudWatch Logs 連携済み

---

## 本構成で実現していること

- 手動操作なしの ECS 自動デプロイ
- アクセスキー不要のセキュアな CI/CD
- 実運用を想定したロール・ログ設計
- インフラとアプリケーションの CI/CD 分離運用

---

## 関連リポジトリ（インフラ側）

Terraform による AWS 本番想定インフラ構築  
https://github.com/Manno-cloud/terraform

---

## 用途

- ECS Fargate + GitHub Actions による CI/CD デモ
- AWS / SRE / クラウドエンジニア向けポートフォリオ
- 実務を想定したアプリケーション自動デプロイサンプル
