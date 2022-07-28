# RT-Thread Linux  CI Environment

一个用于嵌入式实时操作系统 RT-Thread 进行持续集成的容器化环境。

## 使用教程:

### Docker 本地步骤
1. 拉取并启动镜像  `maikebing/rt-thread_linux_env`
2. 代码克隆至已经启动的容器中。 
3. 代码目录 `pkgs --update`
4. 可以使用 `cppcheck --enable=all --std=c99  applications/`  检查代码
5. 直接 scons ， 比如` scons --target=mdk5 `
6. 成果物打包  如果使用mdk5 则文件名 一般为rtthread.bin ， 根据你实际情况 在相关的 ci 中设置就好。 


### GitHub Action 

	https://github.com/marketplace/actions/rt-thread-ci-action
  
按照下面教程方式  放在 你的 项目中。 使用方法如下:

```c
name: RT-Thread

on:
  push:
    branches: [ "master" ]


jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: scons
      uses: actions/checkout@v3
    - name: Setup RT-Thread
      uses: maikebing/rt-thread_linux_env@v1 
      with: 
           TARGET: 'mdk5'
           CPPCHECK: '--enable=all --std=c99 applications/'
 
```

### Azure Pipelines
在代码目录新建 azure-pipelines.yml , 拷贝下面的内容，保存即可。 
```yaml
container:
  image: maikebing/rt-thread_linux_env:latest
  options: --hostname container-test 
 

steps:
- script:  if [ ! -d ~/.env ]; then ln  /env ~/.env  -s;fi
  displayName: "Init env"
- script:  pkgs --printenv;pkgs  --list;pkgs --update
  displayName: "Checkout all packages"
  workingDirectory: $(Build.SourcesDirectory)
- script: cppcheck --enable=all --std=c99  applications/ 
  displayName: "Static Code Analysis"
  workingDirectory: $(Build.SourcesDirectory)
- script: scons --target=mdk5 
  workingDirectory: $(Build.SourcesDirectory)
  displayName: "Build MDK5 Project"
- task: PublishBuildArtifacts@1
  inputs:
    PathtoPublish: '$(Build.ArtifactStagingDirectory)'
    TargetPath: '$(Build.SourcesDirectory)\rtthread.bin'
    ArtifactName: 'rt-thread'
    publishLocation: 'Container'
    StoreAsTar: true
```

 

欢迎关注公众号

![qrcode_for_gh_aca693152e35_258.jpg](https://oss-club.rt-thread.org/uploads/20220727/6aa9248fb5339a63211de082d37c043b.jpg "qrcode_for_gh_aca693152e35_258.jpg")
