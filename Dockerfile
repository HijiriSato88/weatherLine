# 現在の最新の安定版
FROM ruby:3.3.1
# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs default-mysql-client
# ディレクトリを作成する　これはコンテナの中の話
RUN mkdir /myapp


# 作業ディレクトリを指定する
WORKDIR /myapp
#　gemfileをコンテナに追加する
ADD Gemfile /myapp/Gemfile
# gemfile.lockをコンテナに追加する
ADD Gemfile.lock /myapp/Gemfile.lock
# gemfileに記述された依存関係をインストール
RUN bundle install
# そのほかのファイルをmyappに追加
ADD . /myapp