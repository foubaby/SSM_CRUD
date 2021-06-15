package com.foubaby.utils;

import java.util.HashMap;
import java.util.Map;

public class Msg {

    // 状态码
    private int code;

    // 状态吗提示信息
    private String msg;

    private Map<String, Object> extend = new HashMap<>();

    public Msg(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public static Msg success() {
        Msg msg = new Msg(100, "处理成功!");
        return msg;
    }

    public static Msg failed() {
        Msg msg = new Msg(200, "处理失败!");
        return msg;
    }

    public Msg add(String key, Object value) {
        this.extend.put(key, value);
        return this;
    }


    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }

    public Msg() {
    }
}
