#!/usr/bin/env bash

sinstall() {
  helm install \
    --set Zeppelin.Persistence.Config.Enabled=false \
    --set Zeppelin.Persistence.Notebook.Enabled=false \
    --set Zeppelin.ServiceType=NodePort \
    --set Master.ServiceType=NodePort \
    stable/spark
}

srun() {

}

