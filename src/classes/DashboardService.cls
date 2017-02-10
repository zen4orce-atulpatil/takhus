/*
Description : This class is used as a controller class for DashBoard VF page. Purpose of this class is to get, set and data
Created By : Mustafa
Created Date : November 2016
*/

public class DashboardService {
    
	public string taskJson{get;set;}
    public List<Task> lstOpenTask;
    public List<Task> lstDueTask{get;set;}
    public map<Id,User> mapUser;
    public List<Project__c> lstProjects;
    
	//Constructor : getting all data required on page load.
    public  DashboardService(){
        try{
            lstDueTask = new List<Task>();
            lstOpenTask = new List<Task>();
            String uid = UserInfo.getUserId(); 
            lstOpenTask = TurboPLMSelector.getOpenTask(uid);
            taskJson = generateJsonforOpenTask(lstOpenTask);
            lstDueTask = TurboPLMSelector.getOverDueTask(uid); 
        }catch(Exception e){
          System.debug('ERROR'+e.getMessage()); 
       	}            
	}
    
    //purpose of this class id to dsiplay items to approve list on dashboard page.
    public List<ItemsToApproveWrapper> getItemsToApproverDetails(){
        List<ItemsToApproveWrapper> lstItemsToApproveWrapper = new List<ItemsToApproveWrapper>();
    	List<ProcessInstanceWorkitem> lstProcessInstanceWorkitems =  TurboPLMSelector.getProcessInstanceWorkItems(UserInfo.getUserId());
        try{
            map<Id,ProcessInstance> mapProcessInstances  = TurboPLMSelector.getProcessInstances();
        	map<Id,Project__c> mapAllProjects = TurboPLMSelector.mapAllProjects();
            for(ProcessInstanceWorkitem PIW :lstProcessInstanceWorkitems){
                ProcessInstance pi = mapProcessInstances.get(PIW.ProcessInstanceId);
                ItemsToApproveWrapper varITAWrapper = new ItemsToApproveWrapper('Projects and Approvals',mapAllProjects.get(pi.TargetObjectId).Name,pi.CreatedDate);
               	lstItemsToApproveWrapper.add(varITAWrapper);
            }
        }catch(Exception e){
          System.debug('ERROR'+e.getMessage()); 
       }    
       return lstItemsToApproveWrapper;
    }
	
	//purpose of this class is to prepare json of open task
    public static string generateJsonforOpenTask(List<Task> lstOpenTask){
        try{
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
        }catch(Exception e){
          	System.debug('ERROR'+e.getMessage()); 
			return null;            
       }            
    }
    
    // wrapper class to prepare Items to approve list
    public class ItemsToApproveWrapper{
        public String mostRecentApprover{get;set;}
        public String objType{get;set;}
        public String relatedTo{get;set;}
        public DateTime dateSubmitted{get;set;}
        public ItemsToApproveWrapper(String objType, String relatedTo, DateTime dateSubmitted){
            this.objType = objType;
            this.relatedTo = relatedTo;
            this.dateSubmitted = dateSubmitted;
        }
    }
}