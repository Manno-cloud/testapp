FROM nginx:latest

# ローカルの html フォルダをコンテナにコピー
COPY ./html /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
