/*
Description : This class is used as a controller class for Sidebar Component.
Created By : Mustafa
Created Date : November 2016
*/

public class SidebarController {
    public String userImageURL{get;set;}
    public string taskJson{get;set;}
    public string param{get;set;}
    public List<Task> lstOpenTask;
    public List<Task> lstDueTask{get;set;}
     public String loggedInUserId{get;set;}
     public User usr{get;set;}
    //Constructor
    public SidebarController(){ 
    	String uid = UserInfo.getUserId();
    	lstOpenTask = new List<Task>([select Subject,WhatId,Status,ActivityDate from task where OwnerId=:uid]);
    	taskJson = generateJsonforOpenTask(lstOpenTask);
    	//change lstDueTask query where condition "ActivityDate<today" 
    	lstDueTask = new List<Task>([select Subject,WhatId,Status,ActivityDate from task where OwnerId=:uid]);
        loggedInUserId = UserInfo.getUserId();
        usr =[Select Department,Name From User where Id=:loggedInUserId limit 1];
        userImageURL = TopNavigationDomain.getUserImage(uid);
    }
    
    //Purpose of this method is to return Open task in json string
    public static string generateJsonforOpenTask(List<Task> lstOpenTask){
    	JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        Integer count = 1;	
        for(Task tsk: lstOpenTask){
         	gen.writeStartObject();
        	gen.writeStringField('subject', tsk.Subject);
        	gen.writeStringField('relatedTo', tsk.WhatId);
        	gen.writeStringField('status', tsk.status);
        	gen.writeDateField('duedate', tsk.ActivityDate);
        	gen.writeStringField('enbl', '0');
        	gen.writeStringField('level', '0');
        	gen.writeStringField('parent', '');
        	gen.writeStringField('isLeaf', 'false');
        	gen.writeStringField('expanded', 'false');
        	gen.writeStringField('loaded', 'false');
        	gen.writeEndObject();
			count++;
        }
         gen.writeEndArray();
        gen.writeEndObject();
        return gen.getAsString();
    }
}