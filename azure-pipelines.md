``` yml 
container:
  image: maikebing/rt-thread_linux_env:latest
  options: --hostname container-test 
 

steps:
- script:  if [ ! -f ~/.env ]; then ln  /env ~/.env  -s;fi
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