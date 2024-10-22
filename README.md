
# ``AetherFlow``

AetherFlow helps users track their carbon emissions through everyday transactions, provide actionable guidance, and monitor improvement progress.
Project made by Christina Tu and Gabby Sanchez

## Overview

AetherFlow is integrating with the Connect Earth API to accurately calculate the carbon emissions of users' everyday transactions and provide clear insights into the impact of their actions. Additionally, AetherFlow offers challenges to guide users in making eco-friendly decisions that are easy to track and achieve, leading them toward a more sustainable lifestyle. The app to contain the following four key features:

    1. Profile Metrics: Users can view detailed metrics, including their total monthly emissions and a breakdown of emissions by category, providing a clear overview of their environmental impact.

    2. Footprint: AetherFlow allows users to add transaction logs and view each transaction's associated carbon footprint data.

    3. Challenge: AetherFlow enables users to select and undertake carbon footprint reduction challenges tailored to specific categories they want to focus on.

    4. Carbon Diet: AetherFlow allows users to track the status of their selected challenges and mark them as completed upon achievement.

## Topics

### Main Views
- ``StartView``
- ``ProfileMetricsView``
- ``FootprintView``
- ``AddFootprintView``
- ``FootprintEquivalentsListView``
- ``ChallengeCategoriesView``
- ``ChallengeListView``
- ``DietView``

### Other Views
- ``AetherFlowSineWaveLayout``
- ``AetherFlowTabView``
- ``FootprintTransactionRowView``
- ``ChallengeCategoryView``
- ``AetherFlow``
- ``ContentView``

### SwiftData Models
- ``Transaction``
- ``ProfileMetric``
- ``ProfileMetricGroupItem``
- ``Diet``

### Other Models
- ``User``
- ``Challenge``

### Utilities
- ``APIService``
- ``ReadTransactionData``
- ``ReadChallengeData``
