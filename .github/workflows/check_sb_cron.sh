name: check_sb_cron

on:
  workflow_dispatch: # 手动触发工作流
  schedule:
    #- cron: "30 1,13 * * *"  # 每天 北京时间早晚9点30分 各运行一次

jobs:
  execute-commands:
    runs-on: ubuntu-latest
    steps:
      - name: Set up SSHPass
        run: sudo apt-get update && sudo apt-get install -y sshpass

      - name: Get ACCOUNTS_JSON
        id: get-accounts
        run: |
          echo "$ACCOUNTS_JSON" > accounts.json
        env:
          ACCOUNTS_JSON: ${{ secrets.ACCOUNTS_JSON }}
        # 从 GitHub Secrets 获取 ACCOUNTS_JSON 变量，并保存到文件 accounts.json

      - name: Generate SSH Commands
        id: generate-ssh-commands
        run: |
          echo "#!/bin/bash" > sshpass.sh
          while IFS= read -r account; do
            username=$(echo "$account" | jq -r '.username')
            password=$(echo "$account" | jq -r '.password')
            ssh=$(echo "$account" | jq -r '.ssh')

            echo "echo \"Executing for $username@$ssh\"" >> sshpass.sh
            echo "sshpass -p '$password' ssh -o StrictHostKeyChecking=no '$username@$ssh' 'bash <(curl -s https://raw.githubusercontent.com/yutian81/serv00-ct8-ssh/main/check_sb_cron.sh)'" >> sshpass.sh
          done < <(jq -c '.[]' accounts.json)
          chmod +x sshpass.sh

      - name: check_sb_cron
        run: ./sshpass.sh
