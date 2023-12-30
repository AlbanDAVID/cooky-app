## TODO ##

**Priority:**
- [ ] Issue #5
- [ ] Add scroll bar listview
- [ ] Fix photo bug (5% of the time, the app crashes when we take a picture (comes back to home page screen, error: Lost device connection))
- [ ] Categories name and the text "Cooky" in the app bar are not aligned

**Code:**
- [ ] Refacto

**Translation:**
- [ ] Any new language translation is welcome

**UI:**
- [ ] Improve UI

**Bugs:**
- [ ] Minor: indentation: when we add a new step after other steps have been created (step 1, step 2 (while there are already step 1 and 2, for example, we would have to repeat the indentation in relation to the elements already added))
- [ ] Minor: when I delete a field in recipe create and I delete, then I edit: I see the "delete" in the text field to edit
- [ ] Minor: in the edit page: when I delete or add an ingredient, step or tag, and I leave the page without saving and I come back to home and come see again the recipe, the changes are temporarily saved until I leave the page. However, it works as expected when I save the changes (and not just leave the page).

**Features to add:**
- [ ] Improve responsivity: for example, the list view for ingredient does not take the whole screen on big screen (>= 6") (because I did the responsiveness according to 5" screen).
- [ ] Connect to a nextcloud account
- [ ] Backup database (possibility to export, import data and ask for conserve data before the app is uninstalled)
- [ ] Ask for the right of the Cooky logo
- [ ] Add stats page (number of recipes, etc.)
- [ ] In create recipe page or edit page: align show ingredient, show steps and show tags with the others
- [ ] Scrap error, try to add a better error catch (for now: name == null)
- [ ] Check with all police size
- [ ] Add create recipe button inside a category and when we click on it, the category is already there (in the required field when we create a recipe)
- [ ] Make disappear "manually" and "from web" when we click anywhere else
- [ ] Add a message error if the category name is empty (for now, we can't add an empty name, but we don't have a warning)
- [ ] Suggest categories name on the first time the app is launched
- [ ] Save added tags in a BDD
- [ ] Display the tags on two lines and put a blur effect at the end of list view when the list is too long
- [ ] Manage landscape view for all pages
- [ ] Limit number character recipe name (to avoid three little dots if the recipe name is too long)
- [ ] Put some character limit for words (e.g., for difficulty, cost, etc.)
- [ ] Add US units
- [ ] Improve UI of ingredient unit selection
- [ ] Be able to manually enter ingredients, then intuitive entry for quantity
- [ ] Put arrows to show that we can scroll (in a lot of list views like tags, ingredients, etc.)
- [ ] Be able to edit category and move them when we create a recipe or edit (like the home page)
- [ ] Checkbox ingred: save in a BDD
- [ ] Add edit option in ingredients selection page (where there is only delete option for now)
- [ ] Improve scraping (more websites)
- [ ] Add rating recipes (stars)
- [ ] Add utensils section
- [ ] Preparation time (the triad: preparation time, cook time, rest)
- [ ] Integer type for ingredient (for automatically telling how many persons)
- [ ] Possibility to enlarge the text steps
- [ ] Sort recipe by date add + filter by tag
- [ ] Deletion: be able to select several items to delete
- [ ] Print or export as PDF a recipe
- [ ] In the taking picture page: preview the pics if any
