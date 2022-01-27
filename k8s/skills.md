**autocomplete**
```bash
$ yum install bash-completion -y
$ echo 'source  /usr/share/bash-completion/bash_completion' >> ~/.bashrc
$ echo 'source <(kubectl completion bash)'  >> ~/.bashrc
$ . ~/.bashrc
$ kubectl <Tab>
```

