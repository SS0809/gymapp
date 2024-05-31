import express from "express"; 
function fitnessGoal(userData){ 
    const{age,weight,height}=userData; 
    let DailyBurnCalories='2000calories'; 
    if(age>20&&weight>50){ 
        DailyBurnCalories='5000calories';
    } 
    else if(age>20&&weight<50){ 
        DailyBurnCalories='3000calories';
    } 
    return DailyBurnCalories;
} 
export default fitnessGoal; 
