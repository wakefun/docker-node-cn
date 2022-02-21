# node-cn

## 全局依赖
> [BestPractices install global-npm-dependencies](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md#global-npm-dependencies)  

npm6安装依赖的时候使用当前用户的权限去创建文件，因为docker默认是root用户，而npm出于安全考虑默认是不使用root用户安装的，强制使用root用户安装可以通过指令`--unsafe-perm`实现，参见[npm --unsafe-perm](https://docs.npmjs.com/cli/v6/using-npm/config#unsafe-perm)。  

npm7之后安装依赖的权限控制修改了，和安装目录的的权限保持一致而不是以当前用户的权限去创建文件，所以`unsafe-perm`这个指令被移除了，参见 [npm7 changelog_unsafe-perms](https://github.com/npm/cli/blob/release/v7.0.0/CHANGELOG.md#all-lifecycle-scripts)  

故而在docker环境中npm安装一些全局依赖，最好指定安装路径为非root用户，参见[BestPractices install global-npm-dependencies](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md#global-npm-dependencies) 

```shell
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global

ENV PATH=$PATH:/home/node/.npm-global/bin # optionally if you want to run npm global bin without specifying path
```