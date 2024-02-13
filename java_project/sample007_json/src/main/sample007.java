package main;

import org.json.JSONObject;

public class sample007 {
    public static void main(String[] args) {
    	sample007 obj = new sample007();
    	obj.MainProc();
    }

    public void MainProc() {
    	System.out.println("Hello, World!");

    	JSONObject jo = new JSONObject();
        jo.put("name", "Jone");
        jo.put("city", "Seoul");

        System.out.println(jo.toString());	
    }
}
