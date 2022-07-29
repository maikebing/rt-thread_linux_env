``` yml 
container:
  image: maikebing/rt-thread_linux_env:latest
steps:
- bash: rm $HOME/.env -f; ln /env $HOME/.env -s;export PATH=$PATH:$HOME/.env/tools/scripts/:/env/tools/scripts/;pkgs --update
  displayName: "Checkout all packages "
  workingDirectory: $(Build.SourcesDirectory)
- bash: cppcheck --enable=all --std=c99  applications/ 
  displayName: "Static Code Analysis"
  workingDirectory: $(Build.SourcesDirectory)
- bash: scons --target=mdk5 
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
