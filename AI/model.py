# Import necessary libraries
import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.model_selection import train_test_split
import torch
from torch.utils.data import Dataset, DataLoader
import torch.nn as nn
import torch.optim as optim

# Step 1: Generate and save sample data
# -------------------------------------
num_samples = 100

# Generate sample data
np.random.seed(42)
age = np.random.randint(18, 60, size=num_samples)
weight = np.random.randint(50, 100, size=num_samples)
height = np.random.randint(150, 200, size=num_samples)
gender = np.random.choice(['Male', 'Female'], size=num_samples)
activity_level = np.random.choice(['Sedentary', 'Lightly active', 'Moderately active', 'Very active', 'Super active'], size=num_samples)
dietary_preferences = np.random.choice(['Vegetarian', 'Non-vegetarian', 'Vegan', 'Pescatarian'], size=num_samples)
fitness_goal = np.random.choice(['Weight loss', 'Muscle gain', 'Maintenance'], size=num_samples)
diet_plan = np.random.choice(['Plan A', 'Plan B', 'Plan C', 'Plan D', 'Plan E'], size=num_samples)

# Create a DataFrame
data = pd.DataFrame({
    'Age': age,
    'Weight': weight,
    'Height': height,
    'Gender': gender,
    'ActivityLevel': activity_level,
    'DietaryPreferences': dietary_preferences,
    'FitnessGoal': fitness_goal,
    'DietPlan': diet_plan
})

# Save the DataFrame to a CSV file
data.to_csv('user_diet_data.csv', index=False)
print("Sample user_diet_data.csv created successfully!")

# Step 2: Load and preprocess data
# --------------------------------
# Load dataset
data = pd.read_csv('user_diet_data.csv')

# Encode categorical variables
label_encoders = {}
for column in ['Gender', 'ActivityLevel', 'DietaryPreferences', 'FitnessGoal', 'DietPlan']:
    le = LabelEncoder()
    data[column] = le.fit_transform(data[column])
    label_encoders[column] = le

# Standardize numerical variables
scaler = StandardScaler()
data[['Age', 'Weight', 'Height']] = scaler.fit_transform(data[['Age', 'Weight', 'Height']])

# Split data into features and targets
X = data[['Age', 'Weight', 'Height', 'Gender', 'ActivityLevel', 'DietaryPreferences', 'FitnessGoal']].values
y = data['DietPlan'].values

# Train-test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Step 3: Define PyTorch Dataset and DataLoader
# ---------------------------------------------
class DietDataset(Dataset):
    def __init__(self, features, labels):
        self.features = features
        self.labels = labels

    def __len__(self):
        return len(self.features)

    def __getitem__(self, idx):
        return {
            'features': torch.tensor(self.features[idx], dtype=torch.float32),
            'labels': torch.tensor(self.labels[idx], dtype=torch.long)
        }

# Create dataset and dataloader
train_dataset = DietDataset(X_train, y_train)
train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)

# Step 4: Define the Model
# ------------------------
class DietPlanModel(nn.Module):
    def __init__(self, input_size, output_size):
        super(DietPlanModel, self).__init__()
        self.fc1 = nn.Linear(input_size, 128)
        self.fc2 = nn.Linear(128, 64)
        self.fc3 = nn.Linear(64, output_size)
        
    def forward(self, x):
        x = torch.relu(self.fc1(x))
        x = torch.relu(self.fc2(x))
        x = self.fc3(x)
        return x

# Initialize model
input_size = X_train.shape[1]
output_size = len(set(y))

model = DietPlanModel(input_size, output_size)

# Step 5: Define Loss and Optimizer
# ---------------------------------
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# Step 6: Training Loop
# ---------------------
num_epochs = 50

for epoch in range(num_epochs):
    for batch in train_loader:
        features = batch['features']
        labels = batch['labels']

        optimizer.zero_grad()

        outputs = model(features)
        loss = criterion(outputs, labels)

        loss.backward()
        optimizer.step()

  #  print(f'Epoch [{epoch+1}/{num_epochs}], Loss: {loss.item():.4f}')

# Step 7: Save the Model
# ----------------------
torch.save(model.state_dict(), 'diet_plan_model.pth')

# Step 8: Inference
# -----------------
# Load the model
model.load_state_dict(torch.load('diet_plan_model.pth'))
model.eval()

def predict_diet_plan(user_input):
    # Ensure user_input is a DataFrame with appropriate column names
    user_input_df = pd.DataFrame(user_input, columns=['Age', 'Weight', 'Height', 'Gender', 'ActivityLevel', 'DietaryPreferences', 'FitnessGoal'])
    
    # Scale the numerical features
    user_input_df[['Age', 'Weight', 'Height']] = scaler.transform(user_input_df[['Age', 'Weight', 'Height']])
    
    # Convert to tensor
    processed_user_input = torch.tensor(user_input_df.values, dtype=torch.float32)
    
    # Predict
    with torch.no_grad():
        outputs = model(processed_user_input)
    predicted_diet_plan_index = torch.argmax(outputs).item()
    
    # Convert numerical prediction back to the original categorical label
    predicted_diet_plan = label_encoders['DietPlan'].inverse_transform([predicted_diet_plan_index])[0]
    
    return predicted_diet_plan

# Define random user input
random_user_input = np.array([[25, 70, 175, 1, 2, 1, 1]])  # Example input

# Predict diet plan
predicted_diet_plan = predict_diet_plan(random_user_input)
print(f'Predicted Diet Plan: {predicted_diet_plan}')
