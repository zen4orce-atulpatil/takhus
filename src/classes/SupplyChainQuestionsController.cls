/*Description : Purpose of this Class id to Handle Save and Edit Operation of SupplyChainQuestions component.
Created By : Mustafa
Created Date : November 2016*/
public class SupplyChainQuestionsController {
    public String selectedUser{get;set;}
    public Project__c projectRecord{get;set;}
    public String notificationType{get;set;}
    public String notificationMessage{get;set;}
    public map<id,Plant__c> mapOfPlants = new map<id,Plant__c>();
    public map<id,Warehouse__c> mapOfWarehouse = new map<id,Warehouse__c>();
    public List<Plant__c> plantsRecordsList;
    public List<plantsWrapper> WrapperList;
    public List<plantsWrapper> warehouseWrapperList;
    public List<SelectOption> soPlantList;
    public List<SelectOption> soPlantListForWH;
    public String productID{get;set;}
    public boolean reset{get;set;}
    public boolean resetFlag;
	public boolean flagForError{get;set;} 
    
    public SupplyChainQuestionsController(){
        resetFlag = true;
    }
    
    /*Description : Purpose of this method is to reset component when selecting another project in project page.*/
    public void resetComponent(){
      	reset = false;
        WrapperList = null;
        warehouseWrapperList = null;
       
    }
     /*Description : Purpose of this method is to prepare a list of type SelectOption for User object
	whoes department is same as logged in user department.*/
    public List<SelectOption> getUsers(){
         List<SelectOption> lstUsers = new List<SelectOption>();
        try{
            List<User> lstUersOfSameDept = TurboPLMSelector.getUsersOfSameDept('Procurement');
           	lstUsers.add(new SelectOption('0','Select'));
            for(User usr:lstUersOfSameDept ){
                lstUsers.add(new SelectOption(usr.Id,usr.Name));  
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
        return lstUsers;
    }
    //Description : Purpose of this method is return SelectOption List to display plants.
    public List<SelectOption> getPlantDetails(){
        List<SelectOption> plantList = new List<SelectOption>();
        try{
            List<Plant__c> plantsRecordsList =[SELECT Id,Name FROM Plant__c];
            plantList.add(new SelectOption('Select','--Select--'));
            for(Plant__c plant:plantsRecordsList ){
                plantList.add(new SelectOption(plant.Id, plant.Name)); 
                mapOfPlants.put(plant.Id, plant);
            }
        }catch(Exception e){
         	System.debug('ERROR='+e.getMessage());
        }
        return plantList;
    }
     //Description : Purpose of this method is return SelectOption List to display warehouse.
    public List<SelectOption> getWarehouseDetails(){
        List<SelectOption> warehouseList = new List<SelectOption>();
        try{
           	List<Warehouse__c> warehouseRecordsList =[SELECT Id,Name FROM Warehouse__c];
        	warehouseList.add(new SelectOption('Select','--Select--'));
        	for(Warehouse__c wr:warehouseRecordsList ){
            	warehouseList.add(new SelectOption(wr.Id, wr.Name)); 
            	mapOfWarehouse.put(wr.Id, wr);
        	} 
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return warehouseList;
    }
    //Description : Purpose of this method is to prepare wrapper list for plants.
    public List<plantsWrapper> getPlantsList(){
    	try{
            if(WrapperList == null){
                soPlantList=getPlantDetails();
                List<PM_Approved_Mfg_Plant__c> lstApprovedPlants = new List<PM_Approved_Mfg_Plant__c>();
                lstApprovedPlants = turboPLMSelector.getPmApprovedPlants(productID);
                if(lstApprovedPlants.size()>0){
                    WrapperList = new List<plantsWrapper>();
                    for(PM_Approved_Mfg_Plant__c varPlant: lstApprovedPlants){
                        String selectedPlant = String.valueOf(varPlant.Plant__c);
                        WrapperList.add(new plantsWrapper(soPlantList,null,selectedPlant,mapOfPlants,varPlant,null,null)); 
                         
                        }
                }else{
                        WrapperList = new List<plantsWrapper>();
                        WrapperList.add(new plantsWrapper(soPlantList,null,null,mapOfPlants,new PM_Approved_Mfg_Plant__c(),null,null));
                }
            }else{
                Integer count = 0;
                List<plantsWrapper> tempLstPlant = new List<plantsWrapper>();
                for(plantsWrapper p: WrapperList){
                    if(p.isRemove == false){
                        count++;
                    }
                }
                if(count==0){
                    tempLstPlant.add(new plantsWrapper(soPlantList,null,null,mapOfPlants,new PM_Approved_Mfg_Plant__c(),null,null));
                }
            	WrapperList.addAll(tempLstPlant);
        	}
        }catch(Exception e){
         	System.debug('ERROR='+e.getMessage());
        }     
        return WrapperList;
    }
    //Description : Purpose of this method is to prepare wrapper list for warehouse .
    public List<plantsWrapper> getWarehouseList(){
        try{
            
            if(warehouseWrapperList == null){
                soPlantListForWH=getWarehouseDetails();
                List<PM_Approved_WH__c> lstWarehouse = new List<PM_Approved_WH__c>();
                lstWarehouse = turboPLMSelector.getWarehouse(productID);
                if(lstWarehouse.size()>0){ 
                    warehouseWrapperList = new List<plantsWrapper>();
                    for(PM_Approved_WH__c varPlantWh: lstWarehouse){
                        String selectedPlantWH = String.valueOf(varPlantWh.Warehouse__c);
                        warehouseWrapperList.add(new plantsWrapper(null,soPlantListForWH,selectedPlantWH,null,null,mapOfWarehouse,varPlantWh)); 
                    }
                }else{
                        warehouseWrapperList = new List<plantsWrapper>();
                        warehouseWrapperList.add(new plantsWrapper(null,soPlantListForWH,null,null,null,mapOfWarehouse,new PM_Approved_WH__c()));
                    }
            }else{
                    Integer count = 0;
                    List<plantsWrapper> tempLstWarehouse = new List<plantsWrapper>();
                    for(plantsWrapper p: warehouseWrapperList){
                        if(p.isRemoveWh == false){
                            count++;
                        }
                    }
                    if(count==0){
                        tempLstWarehouse.add(new plantsWrapper(null,soPlantListForWH,null,null,null,mapOfWarehouse,new PM_Approved_WH__c()));
                    }
                    warehouseWrapperList.addAll(tempLstWarehouse);
            	}
        }catch(Exception e){
         	System.debug('ERROR='+e.getMessage());
        } 
        return warehouseWrapperList;
    }
    //Description : Purpose of this method is return SelectOption List to product Packages Name.
    public List<Product_Pkg__c> getPackagesDetails(){
        List<Product_Pkg__c> ProdPkgList= new List<Product_Pkg__c>();
        try{
            ProdPkgList =turboPLMSelector.getProductPackages(productID);
        }catch(Exception e){
         	System.debug('ERROR='+e.getMessage());
        } 
    	return ProdPkgList;
    }
    //Description : Purpose of this method is to add another row in plants list.
    public void addPlantWrapperObj(){
        try{
               if(WrapperList == null){
                    WrapperList = new List<plantsWrapper>();
                    soPlantList=getPlantDetails();
                }
            	WrapperList.add(new plantsWrapper(soPlantList,null,null,mapOfPlants,new PM_Approved_Mfg_Plant__c(),null,null));
        	}catch(Exception e){
        		System.debug('ERROR='+e.getMessage());    
        	}
       }

    //Description : Purpose of this method is to add another row in plants list.
    public void addWarehouseWrapperObj(){
        try{
            if(warehouseWrapperList == null){
           	warehouseWrapperList = new List<plantsWrapper>();
            soPlantListForWH=getWarehouseDetails();
        	}
            warehouseWrapperList.add(new plantsWrapper(null,soPlantListForWH,null,null,null,mapOfWarehouse,new PM_Approved_WH__c()));
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());  
        }
    }

    //Description : purpose of this method is save supplychain record details.
    public void saveSupplyChainDetails(){
        boolean isSuccess = true;
        //upsert plants
        List<PM_Approved_Mfg_Plant__c> PlantsToUpsert = new List<PM_Approved_Mfg_Plant__c>();
        List<PM_Approved_Mfg_Plant__c> PlantsToDelete = new List<PM_Approved_Mfg_Plant__c>();
        //upsert warehouse
        List<PM_Approved_WH__c> warehouseToUpsert = new List<PM_Approved_WH__c>();
        List<PM_Approved_WH__c> warehouseToDelete = new List<PM_Approved_WH__c>();
        try{
            flagForError = true;
            for(plantsWrapper pw:WrapperList){
                if(pw.isRemove==false){
                    if(!pw.selManufacturePlant.equalsIgnoreCase('Select')){
                        if(pw.plantRef.Product__c==null){
                            pw.plantRef.Product__c= productID;
                        }
                        pw.plantRef.Plant__c = pw.selManufacturePlant;
                        PlantsToUpsert.add(pw.plantRef);
                    }else{
                        flagForError = false;//check whether this will be replaced by notificationtype variable
                        notificationType = '';
                        notificationMessage = '';
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.SC_Manufacturing_Plant_Validation));
                    }
                }else{
                    if(pw.plantRef.Id!=null){
                        PlantsToDelete.add(pw.plantRef);          	
                    }
                }
                
            }
            //upsert warehouse
            for(plantsWrapper pw:warehouseWrapperList){
                if(pw.isRemoveWh==false){
                    if(!pw.selWarehousePlant.equalsIgnoreCase('Select')){
                        if(pw.varPlantWh.Product__c==null){
                            pw.varPlantWh.Product__c= productID;
                            pw.varPlantWh.Warehouse__c = pw.selWarehousePlant;
                        }
                        pw.varPlantWh.Warehouse__c = pw.selWarehousePlant;    
                        warehouseToUpsert.add(pw.varPlantWh);
                    }else{
                        flagForError = false;
                        notificationType = '';
                        notificationMessage = '';
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.SC_Warehouse_Plant_Validation));
                    }
                }else{
                    if(pw.varPlantWh.Id!=null){
                        warehouseToDelete.add(pw.varPlantWh);          	
                    }
                }
                
            }
            if(flagForError == true){
                //upsert plant
                if(!SupplyChainDomain.upsertManufacturingPlants(PlantsToUpsert)){
                    isSuccess = false;
                }
                //upsert warehouse
                if(!SupplyChainDomain.upsertWarehousePlants(warehouseToUpsert)){
                    isSuccess = false;
                }
                //delete plants
                if(!SupplyChainDomain.deleteManufacturingPlants(PlantsToDelete)){
                    isSuccess = false;
                }
                //delete warehouse
                if(!SupplyChainDomain.deleteWarehousePlants(warehouseToDelete)){
                    isSuccess = false;
                }
                if(isSuccess){
                    notificationType = 'success';
                    notificationMessage = Label.SaveMessage;
                }else{
                    notificationType = 'warning';
                    notificationMessage = Label.PartialSaveMessageRnD;
                }
            }
        }catch(Exception e){
            flagForError = false;
            notificationType = '';
            notificationMessage = '';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,e.getMessage()));
        }
    }
    //Description : purpose of this method is save and submit record and send it to procurement departmentdetails.
     public void submitSCDetailsForApproval()
    {
        try{
            //1.save
            saveSupplyChainDetails();
            if(flagForError == true){
                //2.send the Project for Approval, 
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approving request');
                req.setAction('Approve');
                req.setNextApproverIds(new Id[] {selectedUser});//  Selection of next Approver, 
                Id workItemId = getWorkItemId(projectRecord.id); 
                if(workItemId == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.Approval_Process_Initiated_Error));
                }
                else{
                    req.setWorkitemId(workItemId);
                    // Submit the request for approval
                    Approval.ProcessResult result =  Approval.process(req);
                    if(result.isSuccess()){
                        notificationType = 'success';
                		notificationMessage = Label.SubmitMessage;
                        //3. update the Project Status and Department 
                        ProjectDomain.submitProjectToProcurement(projectRecord);
                        //4.share record
                        Product__share shareProduct = new Product__share();
                        shareProduct.ParentId  = String.valueOf(projectRecord.Product__c); 
                        shareProduct.UserOrGroupId = selectedUser;
                        shareProduct.AccessLevel = 'Edit'; 
                        
                        if(selectedUser != projectRecord.CreatedById){
                            ProjectDomain.insertSharedRecord(shareProduct);            
                        }
                    }else{
                    	notificationType = 'error';
                		notificationMessage = Label.FailureMessage;    
                    }
                } 
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
    }
     //Purpose of this method is to get ProcessInstanceWorkitem record for given object.
    public Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;
        try{
            for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                where p.ProcessInstance.TargetObjectId =: targetObjectId])
            {
                retVal  =  workItem.Id;
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
        return retVal;
    }
    //Description : Wrapper class for manufacturing plants.
    public Class plantsWrapper{
        //for plants
        public List<SelectOption> PlantDetails{get;set;}
        public List<SelectOption> WarehouseDetails{get;set;}
        public List<Product_Pkg__c> prodPkgForSelectedPlant{get;set;}
        public String selManufacturePlant{get;set;}
        public String selWarehousePlant{get;set;}
        public map<id,Plant__c> wrapperMapOfPlants = new map<id,Plant__c>();
        public map<id,Warehouse__c> wrapperMapOfWarehouse = new map<id,Warehouse__c>();
        public PM_Approved_Mfg_Plant__c plantRef  {get;set;}
        public PM_Approved_WH__c varPlantWh  {get;set;}
        public Boolean isRemove{get;set;}
        public Boolean isRemoveWh{get;set;}
       
        public plantsWrapper(List<SelectOption> PlantDetails,List<SelectOption> warehouseList,String selManuPlant,map<id,Plant__c> mapOfPlants,PM_Approved_Mfg_Plant__c plantRef,map<id,Warehouse__c> mapOfWarehouse,PM_Approved_WH__c warehouseRef){
            this.PlantDetails=PlantDetails;
            this.WarehouseDetails=warehouseList;
            this.selManufacturePlant=selManuPlant;
            this.selWarehousePlant= selManuPlant;
            this.wrapperMapOfPlants = mapOfPlants;
            this.wrapperMapOfWarehouse = mapOfWarehouse;
            this.plantRef = plantRef;
            this.varPlantWh =warehouseRef;
            this.isRemove = false;
            this.isRemoveWh = false;
        }
        
        //Description:-Purpose of this method is to set flag for plant removing record.
        public void removePlantRecord(){
            if(isRemove == false){
                this.isRemove = true;
            }
    	}
        //Description:-Purpose of this method is to set flag for plant removing record.
        public void removeWarehouseRecord(){
        	if(isRemoveWh == false){
            	this.isRemoveWh = true;
        	}
    	}
    }
}