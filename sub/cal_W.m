function [w] = cal_W

load peso
pesinho=diag(peso);
load H
w=H'*pesinho*H;