/*
Description : This is wrapper class for PM_QA_Spec__c and related details.
Created By : Mustafa
Created Date : November 2016
*/
public Class PmQaSpec{
    public List<SelectOption> soParamList{get;set;}
    public String selectedParam{get;set;}
    public String selectedTestMethod{get;set;}
    public String range {get;set;}
    public String uom{get;set;}       
    public boolean isRemove{get;set;}
    public PM_QA_Spec__c pmQaSpecRef{get;set;}
    map<id,QA_Spec__c> mapQaSpec;
    
    public PmQaSpec(map<id,QA_Spec__c> mapQaSpec,List<SelectOption> soParamList,String selectedParam,String range,string uom, PM_QA_Spec__c pmQaSpecRef, String selectedTestMethod){
        this.selectedParam = selectedParam;
        this.soParamList=soParamList;
        this.soParamList=soParamList;
        this.range=range;
        this.uom = uom;
        this.pmQaSpecRef=pmQaSpecRef;
        this.mapQaSpec = mapQaSpec;
        this.selectedTestMethod = selectedTestMethod;
        isRemove = false;
    }
    
    //Description : Purpose of this method is to set UOM__c for selected Pm_Qa_Spec.
    public void setQasUnit(){
        if(this.selectedParam!='select'){
            this.uom = mapQaSpec.get(this.selectedParam).UOM__c;    	
        }else{
            this.uom = '';
        }
    }
    
    //Description : Purpose of this method is to set isRemove to false for deleting unckecked record.
    public void removePmQaSpecRecord(){
        if(isRemove == false){
            isRemove = true;
        }
    }  
}