### Objective

Your assignment is to create a Pokémon API from a CSV file using Python and Django.

### Brief

Professor Oak is in trouble! A wild Blastoise wreaked havoc in the server room and destroyed every single machine. There are no backups - everything is lost! Professor Oak quickly scribbles down all the Pokémon from memory and hands them to you on a piece of paper. (`/Data/pokemon.csv`). Your task is to restore the Pokémon Database from that file and create a Pokémon API so that they’re never lost again.

### Tasks

-   Implement assignment using:
    -   Language: **Python**
    -   Framework: **Django**
-   Create a Pokémon Model that includes all fields outlined in `/Data/pokemon.csv`
-   Parse the .csv file and create entries for each row based on the following conditions:
    -   Exclude Legendary Pokémon
    -   Exclude Pokémon of Type: Ghost
    -   For Pokémon of Type: Steel, double their HP
    -   For Pokémon of Type: Fire, lower their Attack by 10%
    -   For Pokémon of Type: Bug & Flying, increase their Attack Speed by 10%
    -   For Pokémon that start with the letter **G**, add +5 Defense for every letter in their name (excluding **G**)
-   Create one API endpoint `/pokemon`
    -   This API endpoint should be searchable, filterable and paginatable
        -   Search: name
            -   Bonus: implement fuzzy search using Levenshtein distance
        -   Filter: HP, Attack & Defense
            -   e.g. `/pokemon?hp[gte]=100&defense[lte]=200`
        -   Pagination: e.g. `/pokemon?page=1`

### Evaluation Criteria

-   **Python** best practices
-   Show us your work through your commit history
-   We're looking for you to produce working code, with enough room to demonstrate how to structure components in a small program
-   Completeness: did you complete the features?
-   Correctness: does the functionality act in sensible, thought-out ways?
-   Maintainability: is it written in a clean, maintainable way?
-   Testing: is the system adequately tested?

