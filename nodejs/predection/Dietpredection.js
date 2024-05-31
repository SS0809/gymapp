import express  from "express"; 
function  recommandDiet(userData){ 
    const{age,weight,height,ActivityLevel,DietRestriction}=userData; 
    let Diet="Balanced-Diet"; 
    if(ActivityLevel=='High'){ 
        Diet="High-Protein";
    } 
    if(ActivityLevel=='Moderate'){
        Diet="High-Carbohydrate";
    } 
    if(DietRestriction.includes('Vegeterian')){ 
        Diet='Vegeterian';
    } 
    else if(DietRestriction.includes('Vegan')){ 
        Diet='Vegan';
    } 
    else if(DietRestriction.includes('Non-Veg')){ 
        Diet='Non-Veg';
    } 
    return Diet;

} 
export default Diet;