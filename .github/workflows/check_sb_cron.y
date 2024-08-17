name: Nezha Dashboard and Agent Monitor

on:
  schedule:
    # 每隔5分钟运行一次，可以根据需要调整时间
    - cron: '30 01,07,13,19 * * *'

jobs:
  check-nezha-processes:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up SSH
      uses: webfactory/ssh-agent@v0.5.3
      with:
        ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

    - name: Check and restart Nezha dashboard and agent processes
      run: |
        ssh -o StrictHostKeyChecking=no ${{ secrets.SERVER_USER }}@${{ secrets.SERVER_IP }} "
        # 终止现有的 dashboard 进程
        pgrep -f 'dashboard' | xargs -r kill
        # 终止现有的 agent 进程
        pgrep -f 'nezha-agent' | xargs -r kill

        # 启动 dashboard
        cd /home/zzzxxx/.nezha-dashboard
        nohup /home/zzzxxx/.nezha-dashboard/start.sh >/dev/null 2>&1 &

        # 启动 agent
        cd /home/zzzxxx/.nezha-agent
        nohup /home/zzzxxx/.nezha-agent/start.sh >/dev/null 2>&1 &"
