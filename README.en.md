<div style="text-align:center">
    <img src="./assets/images/devest.svg" alt="image" width="60%" height="auto">
</div>

# Pokédex

<div style="text-align:center">
    <img src="./assets/images/oak.png" alt="image" width="30%" height="auto">
</div>

Hello Pokémon trainers! I'm Professor Oak, and I have a challenge for you who are eager to show off 
your skills in Flutter and multiplatform development.

In collaboration with my friends at Devest and given that smartphones and the internet are already part of
our daily bread, we thought that instead of having to carry a physical Pokédex in your pocket, 
trainers like you could have the Pokédex accessible on their mobile phones or computers.

Let me tell you more in detail...

## Requirements

### Objective

We have evidence of trainers using Android, Apple phones and computers. So we need the 
Pokédex to run on **Android and iOS**. For people like me who still have our Nokia 3310, 
we can access the Pokédex as a **desktop** or **web application**.

### General description:

The Pokédex should have the following sections:
   - **Pokédex**: List of all available Pokémon.
   - **Captured**: List of Pokémon captured by the trainer.
   - **Pokémon in detail**: When you click on a Pokémon from the Pokédex or Captured list,  
a new screen should open showing more details about the selected Pokémon.

**The menu can be of any type,** and we leave it up to you to decide which one is most suitable.

The data will be obtained from the public Pokémon API called **PokéApi**, [here is its documentation](https://pokeapi.co/docs/v2).

Now we are going to explain in more detail what we want for each screen...

### Pokédex

In this section, we want the trainer to be able to see all the Pokémon available in their region. This
first version of the Pokédex will be tested in the Kanto region, which means that **we only want to show the first 151 Pokémon**.

We also want to give the trainer the opportunity to search for Pokémon by name, so **we will integrate a search
that will filter the list of Pokémon that match the search text**.

Of course, as we mentioned before, **when you click on a Pokémon from the list, another screen opens with the details of that Pokémon**.

### Captured

In this section, we want to see the Pokémon captured by the trainer. After all, that's what the Pokédex is for, right?

The list of captured Pokémon should appear **sorted by its id**. Although we will give the trainer the
possibility to **filter the Pokémon by type** and to **sort them alphabetically**.

The same than in the Pokédex screen, **when clicking on a Pokémon from the list, the details of the Pokémon will be shown**.

### Detailed Pokémon view

This screen will show the information of the selected Pokémon. The design is your choice, but we need to
**show all this data**:
  - Id.
  - Name.
  - Photo.
  - Height and weight (in the unit returned by the API, no need to convert to centimeters or kilograms).
  - Pokémon types.

In addition to all that data, we should be able to **add or remove the Pokémon as captured**. Captured Pokémon
must be stored locally on the phone. The way you store the data is up to you.

Of course, **when navigating back, we must return to the same screen we were on**.

### UI - User Interface

We want the Pokédex to be customizable. Therefore we are going to customize the colors depending on several factors.

By default, **the color palette used in the application and the Top Bar** will be the original color of the Pokédex, which
is the color "Red" or "Boston University Red" (whichever you prefer). You can find its color codes
[in this link](https://www.schemecolor.com/pokemon-colors.php).

To make it even more customizable, **the color palette will change depending on the type of Pokémon captured**.

For example:
- If the trainer has captured 3 Water-type Pokémon, and 2 Grass-type Pokémon, the color palette will be based
on the color associated with the Water type.
- In the case that the trainer does not have captured Pokémon or there is no majority type among the Pokémon
captured (for example, if the trainer has captured 2 Grass-type Pokémon and 2 Water-type Pokémon), the palette
of colors will be the default palette mentioned above.

The Pokémon types can be obtained from the API itself and their associated colors can be consulted at
[this link](https://www.pokemonaaah.net/artsyfartsy/colordex/).

### Extra
   - Previous steps are the minimum requirements, but all improvements added to the user experience (UX) 
or the graphical interface (UI) are welcome.
   - Good practices, clean architecture and the use of any code quality control library will be valued.

## Conclusions

<div style="text-align:center">
    <img src="./assets/images/oak_2.webp" alt="image" width="30%" height="auto">
</div>

Thank you very much for your collaboration, all Pokémon trainers in the world will be very grateful to you!

Ensure you start the Pokédex by cloning this repository, where you are provided with an empty project
that is already executable on all the platforms mentioned. Once you have the Pokédex finished,
you must upload it to a git repository of your choice, and send the link to the Devest team for review.

The trainers are eager, so you have a week to send us the result.

Once it is reviewed, you will receive news to know if you are still in the selection process.

Good luck and... Gotta catch 'em all!