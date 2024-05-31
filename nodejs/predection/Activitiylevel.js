// A simple mock function to simulate an AI model
function calculateActivityLevel(userData) {
    const { age, weight, height, workoutsPerWeek, averageWorkoutDuration } = userData;
    
    // Mock logic to determine activity level
    let activityScore = (workoutsPerWeek * averageWorkoutDuration) / (weight * height / age);
  
    if (activityScore > 1.5) return 'High';
    if (activityScore > 1.0) return 'Moderate';
    return 'Low';
}
export default calculateActivityLevel;
  