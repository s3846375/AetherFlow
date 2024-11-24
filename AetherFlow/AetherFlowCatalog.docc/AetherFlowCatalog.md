# ``AetherFlow``

AetherFlow helps users track their carbon emissions through everyday transactions, provide actionable guidance, and monitor improvement progress.

## Overview

AetherFlow is integrating with the Connect Earth API to accurately calculate the carbon emissions of users' everyday transactions and provide clear insights into the impact of their actions. Additionally, AetherFlow offers challenges to guide users in making eco-friendly decisions that are easy to track and achieve, leading them toward a more sustainable lifestyle. The app to contain the following four key features:

    1. Profile Metrics: Users can view detailed metrics, including their total monthly emissions and a breakdown of emissions by category, providing a clear overview of their environmental impact.

    2. Footprint: AetherFlow allows users to add transaction logs and view each transaction's associated carbon footprint data.

    3. Challenge: AetherFlow enables users to select and undertake carbon footprint reduction challenges tailored to specific categories they want to focus on.

    4. Carbon Diet: AetherFlow allows users to track the status of their selected challenges and mark them as completed upon achievement.

## Topics

### Main Views
- ``StartView``: The starting view of the AetherFlow app.
- ``ProfileMetricsView``: A view that displays user transaction history and carbon emissions statistics, such as total emissions, emission breakdowns, and monthly progress.
- ``FootprintView``: A view that displays a list of transactions stored in the local database, sorted by timestamp in descending order.
- ``AddFootprintView``: A sheet view for adding a new transaction entry. It includes a form with sections for selecting a category, entering transaction details, and setting a date.
- ``FootprintEquivalentsListView``: A view that displays a list of carbon footprint equivalents based on a provided total emissions value.
- ``ChallengeCategoriesView``: A view displaying a grid of carbon footprint reduction challenge categories for the user to select.
- ``ChallengeListView``: A view that displays a list of carbon footprint reduction challenges filtered by a selected category.
- ``DietView``: A view that displays a list of completed and ongoing challenges associated with the user, retrieved from the local database.

### Other Views
- ``AetherFlowSineWaveLayout``: A custom layout that arranges subviews along a sine wave pattern.
- ``AetherFlowTabView``: The main view responsible for navigating between the core features of the AetherFlow app through a TabView.
- ``FootprintTransactionRowView``: A view that displays a single row of transaction details in the FootprintView.
- ``ChallengeCategoryView``: A view that represents an individual challenge category.
- ``AetherFlow``: The main entry point for the AetherFlow app, configuring the app’s main scene and initializing the data model container.
- ``ContentView``: The starting scene of the app initialy set to StartView that prompts the user to log in.

### SwiftData Models
- ``Transaction``: Represents a carbon footprint transaction entry, storing details about a user’s spending activity and its associated carbon emissions.
- ``ProfileMetric``: Represents a user’s carbon emissions profile for a specific month.
- ``ProfileMetricGroupItem``: Represents a group in a user’s carbon emissions profile, providing a breakdown of emissions for a specific category (e.g., “Food”, “Energy”).
- ``Diet``: Represents a diet record that tracks a user’s progress toward completing a challenge in the AetherFlow app.

### Other Models
- ``User``: Represents a user with basic details such as ID, name, email, and profile picture.
- ``Challenge``: Represents an individual challenge within the AetherFlow Challenge feature.

### Utilities
- ``APIService``: A service responsible for calling Connect Earth API endpoints.
- ``ReadTransactionData``: Reads data from JSON file TransactionData and import as a Transaction array.
- ``ReadChallengeData``: Reads data from JSON file ChallengesData and import as a Challenge array.
