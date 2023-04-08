# chirp

chirp is a proximity-based anonymous social media platform that enables users to connect with people who are close to them in proximity. The app uses a unique algorithm to place users in regions based on their location and allows them to post anonymous messages that can be seen by other users in their region.

## Features

- Anonymous social media platform
- Proximity-based region placement algorithm
- Ability to post and view anonymous messages in a user's region

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio or Xcode
- Google Maps API key

### Installation

1. Clone the repo:

    ```git clone https://github.com/mbulling/chirp.git```

2. Navigate to the project directory:

    ```cd chirp```

3. Install dependencies:

    ```flutter pub get```

4. Run the app

    ```flutter run```


## Usage

Upon launching the app, users will be prompted to grant location permissions. Once granted, the app will use the user's location to place them in a region. The app will display anonymous messages posted by other users in the same region. Users can also post their own anonymous messages for other users in their region to see.

## Algorithm

The region placement algorithm uses the Haversine formula to calculate the great-circle distance between two points on a sphere (in this case, the Earth). The algorithm places users in regions based on their location and the radius of the region. The radius is configurable and can be adjusted based on the user density in the area.

## Developers

- Mason Bulling (mcb343@cornell.edu)
- Andrew Choi (asc269@cornell.edu)
- Alex Giang (akg72@cornell.edu)

