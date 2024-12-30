# 天気情報を返すLineBot

LINEのMessaging APIを利用して、地名を入力するとその場所の天気情報を返すLineBot

## 📚 技術スタック

- **Ruby**: 3.3.1  
- **Rails**: 7.1.3.4  
- **データベース**: MySQL  
- **LINE Messaging API**: ユーザーからの入力を受け取り、レスポンスを返す  
- **Docker**: 開発環境のコンテナ化  

---

## 🌟 主な機能

- **地名を入力**: ユーザーが地名を入力すると、以下の情報を３時間ごとで取得・出力します。
  - 都市名
  - 日時
  - 天気
  - 最低気温～最高気温
  - 湿度

---

## 📱 使用画面の例

- **川越の天気予報を取得**
  
  <img src="https://github.com/user-attachments/assets/40e4d3c4-bddb-4212-b2e8-346107a35c33" alt="川越の天気予報を取得" width="300">

- **リクエストのスペルミス**
  
  <img src="https://github.com/user-attachments/assets/f47699f7-c284-40b1-8c9f-9bfc366c07cc" alt="リクエストのスペルミス" width="300">

- **テキスト以外のメッセージを送った場合**
  
  <img src="https://github.com/user-attachments/assets/43898794-4dda-43a3-bca5-9913bdd79738" alt="テキスト以外のメッセージを送った場合" width="300">
