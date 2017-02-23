/*Description : Purpose of this Class id to Handle Save and Edit Operation of R&D question component.
Created By : Mustafa
Created Date : November 2016*/
public with sharing class RndQuestionsController { 
    public String selectedUser{get;set;}
    public Project__c projectRecord{get;set;}
    public String productID{get;set;}
    public List<Bom> bomList;
    public List<SelectOption> soList;
    public List <PmComp> casList;
    public List<SelectOption> soCasList;
    public PmMixInstruction pmMixInstructionsObj;
    public List<PmPhysicalProperties> pmPhyPropList;
    public List<SelectOption> soPhyPropList;
    public List<PmQaSpec> pmQaSpecList;
    public List<SelectOption> soPmQaSpecList;
    public boolean reset{get;set;}
    public String bomDescription{get;set;}
    public String casDescription{get;set;}
    public String pmphyUnit{get;set;}
    public String pmQasUnit{get;set;}
    public String selectedRawMat{get;set;}
    public String selectedRegInv{get;set;}
    public String selectedPhyProp{get;set;}
    public String selectedQas{get;set;}
    public String notificationType{get;set;}
    public String notificationMessage{get;set;}
    public map<id,Reg_Inventory__c> mapRegInventory = new map<id,Reg_Inventory__c>();
    public map<id,RawMaterial__c> mapRawMaterial = new map<id,RawMaterial__c>();
    public map<id,Physical_Properties__c> mapPhysicalPrpperties = new map<id,Physical_Properties__c>();
    public map<id,QA_Spec__c> mapQaSpec = new map<id,QA_Spec__c>();
    public boolean resetFlag;
    Decimal totalBomPercent=0;
    Decimal totalPmInvPercent=0;
    public boolean flagForError{get;set;}
    public boolean allFieldCheck;
    public RndQuestionsController(){
        resetFlag = true;
    }
    
    //Description : Purpose of this method is return SelectOption List to display raw material.
    public List<SelectOption> getRawMaterials(){
        try{
            if(soList == null){
                list<RawMaterial__c> rawMaterialList = new list<RawMaterial__c>();
                soList = new List<SelectOption>();
                soList .add(new SelectOption('Select','--Select--'));
                rawMaterialList = TurboPLMSelector.getAllRawMaterial();
                if(!rawMaterialList.isEmpty()){
                    for(RawMaterial__c rm :rawMaterialList) {
                        soList.add(new SelectOption(rm.id,rm.name));
                        mapRawMaterial.put(rm.id,rm);
                    }
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
        return soList;    
    }
    
    //Description : Purpose of this method is to prepare wrapper list for Bom object.
    public List<Bom> getBomList(){
        try{
            List<Bom> tempLstBom;
            Integer count = 0;
            if(bomList == null){
                solist=getRawMaterials();
                List<Where_Used__c> lstBOM = new List<Where_Used__c>();
                lstBOM = turboPLMSelector.getBomList(productID);
                if(lstBOM.size()>0){
                    bomList = new List<Bom>();
                    for(Where_Used__c varBom: lstBOM){
                        String selectedRawMat = String.valueOf(varBom.RNumber__r.Id);
                        bomList.add(new Bom(mapRawMaterial, solist, varBom.Percent__c,selectedRawMat,varBom)); 
                        bomDescription = mapRawMaterial.get(selectedRawMat).R_Description__c;   
                        System.debug('bomDescription==>'+bomDescription);
                    }
                }else{
                    bomList = new List<Bom>();
                    bomList.add(new Bom(mapRawMaterial, solist, null, null,new Where_Used__c()));
                }
            }
            else{
                tempLstBom = new List<Bom>();
                for(Bom b: bomList){
                    if(b.isRemove == false){
                        count++;
                    }
                }
                if(count==0){
                    tempLstBom.add(new Bom(mapRawMaterial, solist, null, null,new Where_Used__c()));
                }
                bomList.addAll(tempLstBom);
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
            System.debug('Line Number='+e.getLineNumber());
        }            
        return bomList;
    }
    
    //Description : Purpose of this method is to add another row in bom list.
    public void addAnotherBom(){
        try{
            bomDescription = null;
            if(bomList != null){
                bomList.add(new Bom(mapRawMaterial, solist, null, null,new Where_Used__c()));
            }
            else{
                bomList = new List<Bom>();
                solist=getRawMaterials();
                bomList.add(new Bom(mapRawMaterial, solist, null, null,new Where_Used__c()));
            }
            totalBomPercent = 0;
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }            
    }
    
    //Description : Purpose of this method is to return Reg_Inventory__c List.
    private List<Reg_Inventory__c> getCasList(){
        List<Reg_Inventory__c> localCasList = new list<Reg_Inventory__c>();
        try{
            if(soCasList == null){
                soCasList =  new List<SelectOption>();
                localCasList = TurboPLMSelector.getAllRegInventory();
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return localCasList;    
    }
    
    //Description : Purpose of this method is to return SelectOption List.
    private List<SelectOption> getSoCasList(){
    	List<Reg_Inventory__c> localCasList = new list<Reg_Inventory__c>();
        try{
            localCasList = getCasList();
            if(!localCasList.isEmpty()){
               	soCasList.add(new SelectOption('Select','---Select---'));
                for(Reg_Inventory__c cas :localCasList) {   
                    soCasList.add(new SelectOption(cas.id,cas.CAS__c));
                   mapRegInventory.put(cas.Id,cas);
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return soCasList;
    }
    
    //Description : Purpose of this method is to return Reg_Inventory__c List.
    public List<PmComp> getPmCompList(){
        try{
            if(casList == null){
                casList = new List<PmComp>();
                    List<PM_Composition__c> lstPmComposition = new List<PM_Composition__c>();
                    lstPmComposition = TurboPLMSelector.getPmCompositionsByProductId(productID);
                    if(lstPmComposition.size()>0){
                    for(PM_Composition__c varPmComposition:lstPmComposition){
                        casList.add(new PmComp(mapRegInventory, getSoCasList(), varPmComposition.Percent__c, varPmComposition.Regulatory__r.Id,varPmComposition));
                        casDescription = mapRegInventory.get(varPmComposition.Regulatory__r.Id).CAS_Description__c;
                    }
                    }else{
                        casList.add(new PmComp(mapRegInventory, getSoCasList(), null, null,new PM_Composition__c()));   
                    }
            }else{
                Integer count = 0;
                List<PmComp> tempPmCompList = new List<PmComp>();
                for(PmComp varPmComp : casList){
                    if(varPmComp.isRemove == false){
                    	count++;
                    }
                }
                if(count == 0){
                    tempPmCompList.add(new PmComp(mapRegInventory, getSoCasList(), null, null,new PM_Composition__c()));
                }
                casList.addAll(tempPmCompList);
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return casList;
    }
    
    //Description : Purpose of this method is to add another row for Pm_composition.
	public void addAnotherRegInv(){
        try{
            if(casList != null){
                casList.add(new PmComp(mapRegInventory, getSoCasList(), null, null,new PM_Composition__c()));
            }
        }catch(Exception e){ 
        	System.debug('ERROR='+e.getMessage() );
        }
    } 
    
	//Description : Purpose of this method is to get PM_Mix_Instruction__c record if present else create new.
    public PmMixInstruction getPmMixIns(){
        try{
            if(pmMixInstructionsObj == null){
                    List<PM_Mix_Instruction__c> lstPmInstructions = new List<PM_Mix_Instruction__c>();
                    lstPmInstructions = TurboPLMSelector.getPmMixInstructionByProductId(productID);
                    if(lstPmInstructions.size()>0){
                        for(PM_Mix_Instruction__c varPmInstruction :lstPmInstructions){
                            pmMixInstructionsObj=  new PmMixInstruction(lstPmInstructions[0].Order_of_Addition__c,
                                                                        lstPmInstructions[0].Blend__c,
                                                                        lstPmInstructions[0].RXN__c,
                                                                        lstPmInstructions[0].Blend_RXN__c,
                                                                        lstPmInstructions[0].Mixing_Details__c,
                                                                        lstPmInstructions[0]);	
                        }
                    }
                    else{
                        pmMixInstructionsObj=  new PmMixInstruction(null,null,null,null,null,new PM_Mix_Instruction__c());
                    }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return pmMixInstructionsObj;
    }
    
    //Description : Purpose of this method is to Prepare SelectOption List of Physical_Properties.
    private List<SelectOption> getSOPmPhyProp(){
        try{
            soPhyPropList = new  List<SelectOption>();
            List<Physical_Properties__c> localPhyPropList = new list<Physical_Properties__c>();
            if(localPhyPropList.isEmpty()){
                localPhyPropList = TurboPlmSelector.getAllPhyicalProperties();
                soPhyPropList .add(new SelectOption('Select','--Select--'));
                for(Physical_Properties__c p :localPhyPropList ) {
                    soPhyPropList.add(new SelectOption(p.id,p.name));
                    mapPhysicalPrpperties.put(p.id,p);
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
    	return soPhyPropList;
    }
    
    //Description : Purpose of this method is to prepare wrapper list of Pm_PhysicalProperties.
      public List<PmPhysicalProperties> getAllPmPhyPropList(){
          try{
              if(pmPhyPropList == null){
                  soPhyPropList = new  List<SelectOption>();
                  soPhyPropList = getSOPmPhyProp();
                  pmPhyPropList = new List<PmPhysicalProperties>();
                  list<PM_Physical_Properties__c> latPmPhyProperties = TurboPLMSelector.getPhyPropertiesByProductId(productID);
                  if(latPmPhyProperties.size()>0){
                      for(PM_Physical_Properties__c varPmPhyProperties:latPmPhyProperties){
                          pmphyUnit = mapPhysicalPrpperties.get(varPmPhyProperties.Physical_Properties__r.Id).UOM__c;
                          pmPhyPropList.add(new PmPhysicalProperties(mapPhysicalPrpperties,soPhyPropList, varPmPhyProperties.Physical_Properties__r.Id,varPmPhyProperties.Value__c,String.valueOf(varPmPhyProperties.UOM__c),varPmPhyProperties));
                          
                      }
                  }else{
                      pmPhyPropList.add(new PmPhysicalProperties(mapPhysicalPrpperties,soPhyPropList, null,null, null,new PM_Physical_Properties__c()));                
                  }
              }else{
                  List<PmPhysicalProperties> tempPmPhyPropList = new List<PmPhysicalProperties>();
                  Integer count = 0;
                  for(PmPhysicalProperties varPmPhyProp : pmPhyPropList){
                      if(varPmPhyProp.isRemove == false){
                          count ++;
                      }
                  }
                  if(count == 0){
                      tempPmPhyPropList.add(new PmPhysicalProperties(mapPhysicalPrpperties,soPhyPropList, null,null, null,new PM_Physical_Properties__c()));
                  }
                  pmPhyPropList.addAll(tempPmPhyPropList);
              }
          }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return pmPhyPropList;
    }
    
    //Description : Purpose of this method is to add another row in Pm_PhysicalProperties.
     public void addAnotherPmPhyProp(){
         try{
             if(pmPhyPropList != null){
                 pmPhyPropList.add(new PmPhysicalProperties(mapPhysicalPrpperties,soPhyPropList, null,null, null,new PM_Physical_Properties__c())); 
             }
             else{
                 pmPhyPropList = new List<PmPhysicalProperties>();
                 soPhyPropList = new  List<SelectOption>();
                 List<Physical_Properties__c> localPhyPropList = new list<Physical_Properties__c>();
                 localPhyPropList = TurboPlmSelector.getAllPhyicalProperties();
                 if(!localPhyPropList.isEmpty()){
                     soPhyPropList .add(new SelectOption('Select','--Select--'));
                     for(Physical_Properties__c p :localPhyPropList ) {
                         soPhyPropList.add(new SelectOption(p.id,p.name));
                     }
                 }
                 pmPhyPropList.add(new PmPhysicalProperties(mapPhysicalPrpperties,soPhyPropList, null,null, null,new PM_Physical_Properties__c())); 
             }
         }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
    }
    
    /*Description : Purpose of this method is to prepare SelectOption List of QA_Spec__c.*/
    private List<SelectOption> getSoPmQaList(){
        try{
            if(soPmQaSpecList == null){
                List<QA_Spec__c> localQaList = new list<QA_Spec__c>();
                soPmQaSpecList = new List<SelectOption>();
                soPmQaSpecList .add(new SelectOption('Select','--Select--'));
                localQaList = TurboPLMSelector.getAllQaSpecs();
                if(!localQaList.isEmpty()){
                    for(QA_Spec__c p :localQaList) {
                        soPmQaSpecList.add(new SelectOption(p.id,p.Name));
                        mapQaSpec.put(p.id,p);
                    }
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return soPmQaSpecList;    
    }
    
    /*Description : Purpose of this method is to prepare wrapper list for Pm_Qa_Sepacification.*/
     public List<PmQaSpec> getpmQas(){
         try{
             if(pmQaSpecList == null){
                 soPmQaSpecList=getSoPmQaList();
                 pmQaSpecList = new List<PmQaSpec>();
                 List<PM_QA_Spec__c> lstPmQaSpec = new List<PM_QA_Spec__c>();
                 lstPmQaSpec = TurboPLMSelector.getPmQaQcSpecsByProductId(productID);
                 if(lstPmQaSpec.size()>0){
                     for(PM_QA_Spec__c varPmQaSpec : lstPmQaSpec){
                         String selectedParam = String.valueOf(varPmQaSpec.QA_Spec__r.Id);
                         pmQasUnit =mapQaSpec.get(selectedParam).UOM__c;
                         pmQaSpecList.add(new PmQaSpec(mapQaSpec,soPmQaSpecList,selectedParam,varPmQaSpec.Range__c,varPmQaSpec.UOM__c,varPmQaSpec, varPmQaSpec.Test_Method__c));
                           System.debug('pmQasUnit==>'+pmQasUnit);    
                     } 
                 } 
                 else{
                     pmQaSpecList.add(new PmQaSpec(mapQaSpec,soPmQaSpecList, null, null,null,new PM_QA_Spec__c(),null));                
                 }              
             }else{
                 List<PmQaSpec> tempPmQasList = new List<PmQaSpec>();
                 Integer count = 0;
                 for(PmQaSpec varPmQaSpec : pmQaSpecList){
                     if(varPmQaSpec.isRemove == false){
                         count++;
                     }
                 }
                 if(count == 0){
                     tempPmQasList.add(new PmQaSpec(mapQaSpec,soPmQaSpecList, null, null,null,new PM_QA_Spec__c(),null));
                 }
                 pmQaSpecList.addAll(tempPmQasList);
             }
         }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return pmQaSpecList;
    }
    
    /*Description : Purpose of this method is to add another row in PM_QA_Spec__c.*/
     public void addAnotherPmQa(){
         try{
             if(pmQaSpecList != null){
                 pmQaSpecList.add(new PmQaSpec(mapQaSpec,soPmQaSpecList, null,null, null,new PM_QA_Spec__c(),null));
             }
             else{
                 pmQaSpecList = new List<PmQaSpec>();
                 soPmQaSpecList=getSoPmQaList();
                 pmQaSpecList.add(new PmQaSpec(mapQaSpec,soPmQaSpecList, null,null, null,new PM_QA_Spec__c(),null));
             }
         }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
    }
    
    /*Description : Purpose of this method is to check validations before save Data.*/
    public boolean onSaveValidate(){
		boolean casStatus = true;
        try{
    	//cas not repeat validation
    	for(Integer i=0;i<casList.size();i++){
           for(Integer j =i+1;j<casList.size();j++){
                if(casList[i].invSelected == casList[j].invSelected){
    				casStatus = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.RnD_CAS_Repeat_Validation));
    			}
    		}
    	}
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
    	return casStatus; 
    }
   
    /*Description : Purpose of this method is to perform save and delete operation.*/
    public void saveRnDDetails(){//persistData
    	boolean isSuccess = true;
        
        if(onSaveValidate()){
        	try{
            flagForError = true;
            allFieldCheck = true;
            list<Where_Used__c> bomsToUpsert = new  list<Where_Used__c>();
            list<Where_Used__c> bomsToDelete = new  list<Where_Used__c>();
            list<PM_Composition__c> pmCompToUpsert = new list<PM_Composition__c>();
            list<PM_Composition__c> pmCompToDelete = new list<PM_Composition__c>();
            List<Bom> tempBomList = new List<Bom>();//@new
            totalBomPercent = 0;
            totalPmInvPercent = 0;
            for(Bom b:bomList){
                if(b.isRemove == false){
                    tempBomList.add(b);//@new
                    if(!b.rwSelected.equalsIgnoreCase('Select')){
                        System.debug('^&*^&*^^*^*&^ BOM - ' + b);
                        b.bomRef.Percent__c =  b.percent;
                        b.bomRef.RNumber__c = b.rwSelected;
                        if(b.bomRef.Product__c==null){
                            b.bomRef.Product__c = productID;    
                        }
                        bomsToUpsert.add(b.bomRef);   
                        System.debug('#%$&^*(&*(() insertinng in list BOM - ' +b.bomRef);
                        totalBomPercent +=b.percent;    
                    }else{
                        allFieldCheck = false;
                    }
                }
                else{
                    if(b.bomRef.Id!=null){
                        bomsToDelete.add(b.bomRef);            	
                    }
                }
            }
            bomList.clear();//@new
            bomList.addAll(tempBomList);//@new
            List<PmComp> tempPmCompoList = new List<PmComp>();//@new     
            for(PmComp b:casList){
                if(b.isRemove == false){
                    tempPmCompoList.add(b);//@new
                    if(!b.invSelected.equalsIgnoreCase('Select')){
                        b.PmCompRef.Percent__c =  b.percent;
                        b.PmCompRef.Regulatory__c = b.invSelected;
                        if(b.PmCompRef.Project__c==null){
                            b.PmCompRef.Project__c = productID;
                        }
                        pmCompToUpsert.add(b.PmCompRef);        
                        totalPmInvPercent +=b.percent;
                    }else{
                        allFieldCheck = false;
                    }
                }
                else{
                    if(b.PmCompRef.Id!=null){
                        pmCompToDelete.add(b.PmCompRef);            	
                    }
                }
            }  
            casList.clear();//@new
            casList.addAll(tempPmCompoList);//@new
            if(pmMixInstructionsObj!=null ){
                if(pmMixInstructionsObj.pmMixInsRef.Project__c==null ){
                    pmMixInstructionsObj.pmMixInsRef.Project__c = productID;
                }
                if(!pmMixInstructionsObj.selectedReaction.equalsIgnoreCase('Select')){
                    if(pmMixInstructionsObj.selectedReaction.equalsIgnoreCase('RXN')){
                        pmMixInstructionsObj.pmMixInsRef.RXN__c = true;
                        pmMixInstructionsObj.pmMixInsRef.Blend__c = false;
                        pmMixInstructionsObj.pmMixInsRef.Blend_RXN__c = false;
                    }else if(pmMixInstructionsObj.selectedReaction.equalsIgnoreCase('Blend')){
                        pmMixInstructionsObj.pmMixInsRef.RXN__c = false;
                        pmMixInstructionsObj.pmMixInsRef.Blend__c = true;
                        pmMixInstructionsObj.pmMixInsRef.Blend_RXN__c = false;
                    } else if(pmMixInstructionsObj.selectedReaction.equalsIgnoreCase('Blend/RXN')){
                        pmMixInstructionsObj.pmMixInsRef.RXN__c = false;
                        pmMixInstructionsObj.pmMixInsRef.Blend__c = false;
                        pmMixInstructionsObj.pmMixInsRef.Blend_RXN__c = true;
                    }   
                }else{
                        allFieldCheck = false;
                    }
                pmMixInstructionsObj.pmMixInsRef.Mixing_Details__c=pmMixInstructionsObj.mixingDetails;
                pmMixInstructionsObj.pmMixInsRef.Order_of_Addition__c=pmMixInstructionsObj.orderOfAddition;
            }
            list<PM_Physical_Properties__c> pmPhToUpsert = new  list<PM_Physical_Properties__c>();
            list<PM_Physical_Properties__c> pmPhToDelete = new  list<PM_Physical_Properties__c>();
            list<PmPhysicalProperties> tempPmPhysicalProperties = new List<PmPhysicalProperties>();//@new    
            for(PmPhysicalProperties b:pmPhyPropList){
                System.debug('%%%%%%%%%%%%%%%%%%%%%%%%% b - ' + b.uom);
                if(b.isRemove == false){
                    tempPmPhysicalProperties.add(b);//@new
                    if(!b.selectedParam.equalsIgnoreCase('Select')){
                        b.pmPhyPropRef.Physical_Properties__c=b.selectedParam;
                        b.pmPhyPropRef.Value__c = b.value;
                        //b.pmPhyPropRef.UOM__c = b.uom;
                        if(b.pmPhyPropRef.Project__c==null){
                            b.pmPhyPropRef.Project__c = productID;    
                        }
                        pmPhToUpsert.add(b.pmPhyPropRef);  
                        System.debug('@@@@@@@@@@ while inserting in upsert list - ' + b.pmPhyPropRef);
                    }else{
                       allFieldCheck = false;
                    }
                }
                else{
                    if(b.pmPhyPropRef.Id!=null){
                        pmPhToDelete.add(b.pmPhyPropRef);            	
                    }
                }
            }
            pmPhyPropList.clear();//@new
            pmPhyPropList.addAll(tempPmPhysicalProperties);//@new    
                
            list<PM_QA_Spec__c> pmQaToUpsert = new list<PM_QA_Spec__c>();
            list<PM_QA_Spec__c> pmQaToDelete = new list<PM_QA_Spec__c>();
            list<PmQaSpec> tempPmQaSpec = new List<PmQaSpec>();//@new
            for(PmQaSpec b:pmQaSpecList){
                if(b.isRemove==false){ 
                    tempPmQaSpec.add(b);//@new
                    if(!b.selectedParam.equalsIgnoreCase('Select')){
                        b.pmQaSpecRef.QA_Spec__c =  b.selectedParam;
                        b.pmQaSpecRef.Range__c = b.range;
                        if( b.pmQaSpecRef.Product__c==null){
                            b.pmQaSpecRef.Product__c = productID;
                        }
                        pmQaToUpsert.add(b.pmQaSpecRef);     
                    }else{
                        allFieldCheck = false;
                    }
                }
                else{
                    if(b.pmQaSpecRef.Id!=null){
                        pmQaToDelete.add(b.pmQaSpecRef);            	
                    }
                }
            }
            pmQaSpecList.clear();
            pmQaSpecList.addAll(tempPmQaSpec);//@new
                
                if(!RndQuestionsDomain.upsertBom(bomsToUpsert)){
                    isSuccess = false;
                }
                System.debug('#%$&^*(&*(() after upsert in list BOM - ' +bomsToUpsert);
                if(!RndQuestionsDomain.upsertPmComp(pmCompToUpsert)){
                    isSuccess = false; 
                }
                if(!RndQuestionsDomain.upsertPmMixInstruction(pmMixInstructionsObj.pmMixInsRef)){
                    isSuccess = false;
                }
                if(!RndQuestionsDomain.upsertPmPhysicalPrperties(pmPhToUpsert)){
                    isSuccess = false;
                }
                System.debug('$$$$$$$$$$$$$$$$$ after upsert operation pmPhToUpsert - ' + pmPhToUpsert);
                if(!RndQuestionsDomain.upertPmQaSpec(pmQaToUpsert)){
                    isSuccess = false;
                }
                if(!RndQuestionsDomain.deleteBoms(bomsToDelete)){
                    isSuccess = false;	
                }
                if(!RndQuestionsDomain.deletePmComposition(pmCompToDelete)){
                    isSuccess = false;
                }
                if(!RndQuestionsDomain.deletePmPhysicalProperties(pmPhToDelete)){
                    isSuccess = false;
                }
                if(!RndQuestionsDomain.deletePmQaSpec(pmQaToDelete)){
                    isSuccess = false;
                }
                if(isSuccess){
                    notificationType = 'success';
                    notificationMessage = Label.SaveMessage;
                }else{
                    notificationType = 'warning';
                    notificationMessage = Label.PartialSaveMessageRnD;
                }
                
                bomList = new List<Bom>();
                if(soList == null){
                    soList = new List<SelectOption>();
                    soList =  getRawMaterials();
                }
                for(Where_Used__c w: bomsToUpsert){ //update Ref object inside BOM Wrapper 
                    bomList.add(new Bom(mapRawMaterial, soList,w.Percent__c,w.RNumber__c,w));
                }
                casList = new list<PmComp>();
                soCasList= getSoCasList();
                for(PM_Composition__c w: pmCompToUpsert){//update Ref object inside RegInv Wrapper 
                    casList.add(new PmComp(mapRegInventory, soCasList, w.Percent__c,w.Regulatory__c, w));
                }
                
                pmPhyPropList = new List<PmPhysicalProperties>();
                List<SelectOption> lstsoParamList =  getSOPmPhyProp();
               // soParamList = getSOPmPhyProp();
                //soPhyPropList= getSOPmPhyProp();
                //list<PM_Physical_Properties__c> trial = TurboPLMSelector.getPhyPropertiesByProductId(productID);
                for(PM_Physical_Properties__c varPmPhyProp : pmPhToUpsert){
                    System.debug('^^^^^^^^^^^^^^^^^^^^^ varPmPhyProp.UOM__c - ' + varPmPhyProp.UOM__c);
                    pmPhyPropList.add(new PmPhysicalProperties(mapPhysicalPrpperties,lstsoParamList, varPmPhyProp.Physical_Properties__c, varPmPhyProp.Value__c,varPmPhyProp.UOM__c,varPmPhyProp ));
                }
                
                pmQaSpecList = new List<PmQaSpec>();
                List<SelectOption> lstsoQaSpec = getSoPmQaList();
                for(PM_QA_Spec__c varPmQaSpec:pmQaToUpsert){
                    pmQaSpecList.add(new PmQaSpec(mapQaSpec,lstsoQaSpec, varPmQaSpec.QA_Spec__c,varPmQaSpec.Range__c,varPmQaSpec.UOM__c,varPmQaSpec, null));	
                }
                
            }catch(Exception e){
                flagForError = false;
                System.debug('ERROR=>'+e);
                //notificationType = 'error';
               // notificationMessage = e.getDmlMessage(0);// Label.FailureMessage;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,e.getDmlMessage(0)));
            }  
        }
        //return null;
    }
     /*Description : Purpose of this method is to check validations before save Data.*/
    public boolean onSubmitValidate(){
		boolean Status;
    try{
    	Decimal bomPercent = 0;
    	Decimal casPercent = 0;
    	boolean bomStatus = true;
    	boolean casStatus = true;
        
        //BOM Percentage Validation 
    	for(Bom objBOM:bomList){
    		bomPercent = bomPercent + objBOM.percent;
    	}
    	if(bomPercent <100){
    		bomStatus = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'BOM percentage should be 100%'));
    	}
        
        //cas percent validation  PmComp
        for(PmComp objCAS:casList){
            casPercent = casPercent+ objCAS.percent;
            
        }
        if(casPercent <100){
    			casStatus = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'CAS percentage should be 100%'));
                
    		}
        if(bomStatus == true && casStatus == true){
            Status = true;
            flagForError = true;
        }else{
            Status = false;
            flagForError = false;
        }
        //all fields are filled or not validation
        if(allFieldCheck == false){
            flagForError = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.SubmitValidationMessage));
        }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
    	return Status; 
    }
    /*Description : Purpose of this method is to submit the product*/
    public void submitRnDDetailsForApproval()
    {
        try{
            //1.save
            saveRnDDetails();
            
            if(onSubmitValidate()){
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
                        ProjectDomain.submitProjectToSupplyChain(projectRecord);
                        
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
        }/*else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'please enter all details'));
                
            }*/
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
    }
    
    //Description:- Purpose of this method is to get ProcessInstanceWorkitem record for given object.
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
    
    /*Description : Purpose of this method is to reset component when selecting another project in project page.*/
    public void resetComponent(){
      	reset = false;
        bomList = null;
        casList = null;
        pmMixInstructionsObj = null;
        pmPhyPropList = null;
        pmQaSpecList = null;
    }
    
    /*****************Wrapper Classes***************************/
    //Description : Wrapper class for Bom object.
    public class Bom {
        public List<SelectOption> rawMaterialList{get;set;}
        public Decimal percent{get;set;}
        public String rwSelected{get;set;}
        public String wrapperBomDescription{get;set;}
        public Boolean isRemove{get;set;}
        public Where_Used__c bomRef  {get;set;} 
        map<id,RawMaterial__c> wrapperMapRawMaterial;
        
        public Bom(map<id,RawMaterial__c> mapRawMaterial,List<SelectOption> rawMaterialList, Decimal percent, String rwSelected, Where_Used__c bomRef){
            this.rawMaterialList = rawMaterialList;
            this.percent = percent;
            this.rwSelected = rwSelected;
            isRemove = false;
            this.wrapperMapRawMaterial = mapRawMaterial;
            if(rwSelected != null){
                this.wrapperBomDescription = mapRawMaterial.get(rwSelected).R_Description__c;			
            }          
            this.bomRef = bomRef;
        }
        
        //Descritption:- Purpose of this method is to Set descriprion for selected Raw_Material record.
        public void setBomDescription(){
            if(this.rwSelected!='Select'){
                this.wrapperBomDescription = wrapperMapRawMaterial.get(this.rwSelected).R_Description__c;        	
            }else{
                this.wrapperBomDescription = '';
            }
        }
        
        //Description:- Purpose of this method is to set flag for removing bom record.
        public void removeBomRecord(){
            if(isRemove == false){
                isRemove = true;
            }
            else{
                isRemove = false;	
            }
        }
    }
    
    //Description : Wrapper class for PM_Composition__c object.
    public class PmComp {
        public List<SelectOption> soCasList{get;set;}
        public Decimal percent{get;set;}
        public String invSelected{get;set;}
        public String wrapperCasDescription{get;set;}
        public List<Reg_Inventory_Detail__c> regInvDetailList{get;set;}
        public PM_Composition__c PmCompRef  {get;set;} 
        public Map<id,PmRegClear> pmClearMap{get;set;}
        public Boolean isRemove{get;set;}
        map<id,Reg_Inventory__c> mapRegInventory;
        public PmComp(map<id,Reg_Inventory__c> mapRegInventory, List<SelectOption> soCasList, Decimal percent, String invSelected, PM_Composition__c PmCompRef){
            this.soCasList = soCasList;
            this.invSelected = invSelected;
            this.percent = percent;
            isRemove=false;
            this.mapRegInventory = mapRegInventory;
            if(invSelected!=null){
				this.wrapperCasDescription = mapRegInventory.get(this.invSelected).CAS_Description__c;                
                this.regInvDetailList = mapRegInventory.get(this.invSelected).Reg_Inventory_Detail__r;
            }
            this.PmCompRef = PmCompRef;
	    }

        //Description : Purpose of this method is to set description of selected Reg>Inventory.
        public void setCasDescription(){
        	if(this.invSelected!='Select'){
				this.wrapperCasDescription = mapRegInventory.get(this.invSelected).CAS_Description__c; 
                this.regInvDetailList = mapRegInventory.get(this.invSelected).Reg_Inventory_Detail__r;//Name of reg
        	}else{
        		this.wrapperCasDescription = '';
        	}
        }
        
        //Description : Purpose of this method is to set isRemove to false for deleting unckecked record.
    	public void removePmCompRecord(){
			if(isRemove == false){
        		isRemove = true;
            }
            else{
            	isRemove = false;
            }
        }
    }
    
    public Class PmRegClear{
        public String isECInv{get;set;} 
        public String isIECSC{get;set;} 
        public String isTSCA{get;set;} 
        public PmRegClear(String isECInv,String isIECSC,String isTSCA){
            this.isECInv=isECInv;
            this.isIECSC=isIECSC;
            this.isTSCA=isTSCA;
        }
    }
    
    //Description : Wrapper class for  object PM_Mix_Instruction__c object.
    public Class PmMixInstruction{
        public List<SelectOption> soReactionsList{get;set;}
        public String selectedReaction{get;set;}
        public String orderOfAddition{get;set;} 
        public Boolean isBlend{get;set;} 
        public Boolean isRxn{get;set;} 
        public Boolean isBlendRxn{get;set;} 
        public String mixingDetails{get;set;} 
        public PM_Mix_Instruction__c pmMixInsRef{get;set;}
        
        public PmMixInstruction(String orderOfAddition,Boolean isBlend,Boolean isRxn,Boolean isBlendRxn,String mixingDetails,PM_Mix_Instruction__c pmMixInsRef){
            
            this.soReactionsList = new List<SelectOption>();
            this.soReactionsList.add(new SelectOption('Select','--Select--'));
            this.soReactionsList.add(new SelectOption('RXN','RXN'));
            this.soReactionsList.add(new SelectOption('Blend','Blend'));
            this.soReactionsList.add(new SelectOption('Blend/RXN','Blend/RXN'));
            
            if(isBlend == true){
                selectedReaction = 'Blend';
                isBlend = true;
            }
            else if(isBlendRxn == true){
                selectedReaction = 'Blend/RXN';
                isBlendRxn = true;
            }
            else if(isRxn == true){
                selectedReaction = 'RXN'; 
                isRxn = true;
            }
            else{
                this.isBlend=false;
                this.isRxn=false;
                this.isBlendRxn=false;            
            }
            this.orderOfAddition=orderOfAddition;
            this.mixingDetails=mixingDetails;   
            this.pmMixInsRef=pmMixInsRef;
        }
    }
  
   //Description : Wrapper class for PM_Physical_Properties__c object  object.
   public Class PmPhysicalProperties{
       public List<SelectOption> soParamList{get;set;}
       public  String selectedParam{get;set;}
       public String value{get;set;}
       public string uom{get;set;}
       public Boolean isRemove{get;set;}
       public PM_Physical_Properties__c pmPhyPropRef{get;set;}
       map<id,Physical_Properties__c> mapPhysicalProperties;
       
       public PmPhysicalProperties(map<id,Physical_Properties__c> mapPhysicalProperties, List<SelectOption> soParamList,String selectedParam,String value,String uom, PM_Physical_Properties__c pmPhyPropRef){
           this.soParamList=soParamList;
           this.selectedParam=selectedParam;
           this.value=value;
           this.uom = uom;
           this.pmPhyPropRef=pmPhyPropRef;
           this.mapPhysicalProperties = mapPhysicalProperties;
           isRemove = false;
       }
    
    	//Description : Purpose of this method is to set UOM__c for selected Physical_Property.
        public void setUOM(){
            if(this.selectedParam!='Select'){
                this.uom = mapPhysicalProperties.get(this.selectedParam).UOM__c;    	
            }else{
                this.uom = '';
            }
        }
       
    	//Description : Purpose of this method is to set isRemove to false for deleting unckecked record.
    	public void removePmPhyRecord(){
            if(isRemove == false){
                isRemove = true;
            }
            else{
                isRemove = false;
            }
		}
  	}
  
    /*Description : Purpose of this method is to prepare a list of type SelectOption for User object
	whoes department is same as logged in user department.*/
    public List<SelectOption> getUsers(){
		List<SelectOption> lstUsers = new List<SelectOption>();
        try{
            List<User> lstUersOfSameDept = TurboPLMSelector.getUsersOfSameDept('SC Opt');
            lstUsers.add(new SelectOption('0','Select'));
            if(lstUersOfSameDept == null || lstUersOfSameDept.size() == 0)
               return lstUsers; 	
            for(User usr:lstUersOfSameDept ){
                lstUsers.add(new SelectOption(usr.Id,usr.Name));  
            }
        }catch(Exception e){
        	System.debug('ERROR = '+e.getMessage());        
        }
        return lstUsers;
    }
}