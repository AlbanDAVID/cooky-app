import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @addDelightfulRecipe.
  ///
  /// In en, this message translates to:
  /// **'Add delightful recipe'**
  String get addDelightfulRecipe;

  /// No description provided for @addFromWeb.
  ///
  /// In en, this message translates to:
  /// **'Add from web'**
  String get addFromWeb;

  /// No description provided for @messageDialBoxAddFromWeb.
  ///
  /// In en, this message translates to:
  /// **'Should work on marmiton.org, cuisineaz.com \n Will retireve : recipe name, ingredients ans steps'**
  String get messageDialBoxAddFromWeb;

  /// No description provided for @pastUrl.
  ///
  /// In en, this message translates to:
  /// **'Paste URL here'**
  String get pastUrl;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get add;

  /// No description provided for @beta.
  ///
  /// In en, this message translates to:
  /// **'(beta)'**
  String get beta;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add a category'**
  String get addCategory;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure ?'**
  String get areYouSure;

  /// No description provided for @confirmLongPress1.
  ///
  /// In en, this message translates to:
  /// **'Confirm the desired option with a long press'**
  String get confirmLongPress1;

  /// No description provided for @deleteAllRecipes.
  ///
  /// In en, this message translates to:
  /// **'Delete all recipes'**
  String get deleteAllRecipes;

  /// No description provided for @deleteAllRecipesAndCategories.
  ///
  /// In en, this message translates to:
  /// **'Delete all recipes and categories'**
  String get deleteAllRecipesAndCategories;

  /// No description provided for @actionAfterLongPress1.
  ///
  /// In en, this message translates to:
  /// **'Yes, I want to delete this category and their recipes'**
  String get actionAfterLongPress1;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// No description provided for @editDelete.
  ///
  /// In en, this message translates to:
  /// **'Edit/Delete'**
  String get editDelete;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @infoMessage1.
  ///
  /// In en, this message translates to:
  /// **'All recipes inside this category will get the new category name'**
  String get infoMessage1;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @confirmLongPress2.
  ///
  /// In en, this message translates to:
  /// **'Yes, I want to delete this recipe'**
  String get confirmLongPress2;

  /// No description provided for @confirmLongPress3.
  ///
  /// In en, this message translates to:
  /// **'Yes, I want to delete all recipes of this category'**
  String get confirmLongPress3;

  /// No description provided for @confirmLongPress4.
  ///
  /// In en, this message translates to:
  /// **'Confirm the deletion with a long press'**
  String get confirmLongPress4;

  /// No description provided for @addCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Add category (required)'**
  String get addCategoryRequired;

  /// No description provided for @addRecipeName.
  ///
  /// In en, this message translates to:
  /// **'Add recipe name'**
  String get addRecipeName;

  /// No description provided for @recipeName.
  ///
  /// In en, this message translates to:
  /// **'Recipe name:'**
  String get recipeName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category:'**
  String get category;

  /// No description provided for @addTotalTime.
  ///
  /// In en, this message translates to:
  /// **'Add total time'**
  String get addTotalTime;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total time:'**
  String get totalTime;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @addDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Add difficulty'**
  String get addDifficulty;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty:'**
  String get difficulty;

  /// No description provided for @addCost.
  ///
  /// In en, this message translates to:
  /// **'Add cost'**
  String get addCost;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost:'**
  String get cost;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @addPicture.
  ///
  /// In en, this message translates to:
  /// **'Add picture'**
  String get addPicture;

  /// No description provided for @noPic.
  ///
  /// In en, this message translates to:
  /// **'No photo selected'**
  String get noPic;

  /// No description provided for @chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseGallery;

  /// No description provided for @takePic.
  ///
  /// In en, this message translates to:
  /// **'Take a picture'**
  String get takePic;

  /// No description provided for @addPicture2.
  ///
  /// In en, this message translates to:
  /// **'Add the picture'**
  String get addPicture2;

  /// No description provided for @picture.
  ///
  /// In en, this message translates to:
  /// **'Picture : '**
  String get picture;

  /// No description provided for @previewPicture.
  ///
  /// In en, this message translates to:
  /// **'Preview picture'**
  String get previewPicture;

  /// No description provided for @addIngred.
  ///
  /// In en, this message translates to:
  /// **'Add ingredients'**
  String get addIngred;

  /// No description provided for @addIngred2.
  ///
  /// In en, this message translates to:
  /// **'Add an ingredient'**
  String get addIngred2;

  /// No description provided for @ingredName.
  ///
  /// In en, this message translates to:
  /// **'Ingredient name'**
  String get ingredName;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @showIngred.
  ///
  /// In en, this message translates to:
  /// **'Show Ingredients'**
  String get showIngred;

  /// No description provided for @addSteps.
  ///
  /// In en, this message translates to:
  /// **'Add steps'**
  String get addSteps;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @stepCasLock.
  ///
  /// In en, this message translates to:
  /// **'STEP'**
  String get stepCasLock;

  /// No description provided for @addNewStep.
  ///
  /// In en, this message translates to:
  /// **'Add a new step'**
  String get addNewStep;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @writeStep.
  ///
  /// In en, this message translates to:
  /// **'Write the step here'**
  String get writeStep;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @showSteps.
  ///
  /// In en, this message translates to:
  /// **'Show steps'**
  String get showSteps;

  /// No description provided for @addTags.
  ///
  /// In en, this message translates to:
  /// **'Add tags'**
  String get addTags;

  /// No description provided for @writeTag.
  ///
  /// In en, this message translates to:
  /// **'Write a tag here'**
  String get writeTag;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add a tag'**
  String get addTag;

  /// No description provided for @showTags.
  ///
  /// In en, this message translates to:
  /// **'Show tags'**
  String get showTags;

  /// No description provided for @confirmExit.
  ///
  /// In en, this message translates to:
  /// **'Yes, exit'**
  String get confirmExit;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @areYouSureExit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get areYouSureExit;

  /// No description provided for @saveEditLater.
  ///
  /// In en, this message translates to:
  /// **'You can save changes and edit later'**
  String get saveEditLater;

  /// No description provided for @createRecipe.
  ///
  /// In en, this message translates to:
  /// **'Create a recipe'**
  String get createRecipe;

  /// No description provided for @editRecipe.
  ///
  /// In en, this message translates to:
  /// **'Edit recipe'**
  String get editRecipe;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @startToCook.
  ///
  /// In en, this message translates to:
  /// **'Start to cook!'**
  String get startToCook;

  /// No description provided for @showSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Show suggestions'**
  String get showSuggestion;

  /// No description provided for @listTags.
  ///
  /// In en, this message translates to:
  /// **'Appetizer,Healthy,Starter,Main Course,Dessert,Vegetarian,Vegan,Gluten-Free,Easy,Quick,Indulgent,Spicy,Sweet,Savory,Balanced,Traditional,Fusion,Exotic,Comfort Food,Light,Grilled,Baked,Fish,Meat,Chicken,Beef,Pork,Vegetables,Pasta,Rice,Soup,Salad,Sandwich,Breakfast,Brunch,Dinner,Party,Family Meal,Friends Gathering,Picnic'**
  String get listTags;

  /// No description provided for @listCommonDishes.
  ///
  /// In en, this message translates to:
  /// **'Ratatouille,Beef Bourguignon,Blanquette de Veau,Cassoulet,Coq au Vin,Bouillabaisse,Duck Confit,Moules Marinières,Gratin Dauphinois,Quiche Lorraine,Raclette,Pot-au-Feu,Beef Daube,Crepes,French Onion Soup,Tarte Tatin,Cheese Soufflé,Casseroles,Beef Stroganoff,Roast Chicken,Gratin Potatoes,Lasagna,Sushi,Chicken Tikka Masala,Pad Thai,Tacos,Pizza,Spaghetti Bolognese,Biryani,Chicken Tajine,Paella,Burger,Grilled Salmon,Tom Yum Soup,Fondue,Sandwich,Chicken Caesar Salad,Sushi Bowl,Omelette,Niçoise Salad,Gyudon,Breton Galette,Carbonara,Lemon Tart,Chili Con Carne,Chicken Katsu,Chicken Curry,Spaghetti Aglio e Olio,Ramen Soup,Lok Lak Beef,Banh Mi,Apple Pie,Strawberry Pie'**
  String get listCommonDishes;

  /// No description provided for @listCommonIngredients.
  ///
  /// In en, this message translates to:
  /// **'Butter, Sugar, Flour, Milk, Egg(s), Garlic, Onion(s), Shallot(s), Parsley, Thyme, Rosemary, Basil, Oregano, Salt, Pepper, Olive Oil, Cheese, Rice, Potato(es), Carrot(s), Mushroom(s), Tomato(es), Spinach, Zucchini, Eggplant, Chicken, Beef, Pork, Fish, Shrimp, Honey, Soy Sauce, Mustard, Balsamic Vinegar, Lemon, Lemon Juice, Chocolate, Walnut(s), Almond(s), Cinnamon, Ginger, Nutmeg, Clove(s), Vanilla, Tomato Sauce, Mayonnaise, Ketchup, Tomato Paste, Chili Powder, Cumin, Curry, Paprika'**
  String get listCommonIngredients;

  /// No description provided for @listDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Easy,Medium,Hard'**
  String get listDifficulty;

  /// No description provided for @listCost.
  ///
  /// In en, this message translates to:
  /// **'Budget-friendly,Average,Expensive'**
  String get listCost;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @tsp.
  ///
  /// In en, this message translates to:
  /// **'tablespoon'**
  String get tsp;

  /// No description provided for @listUnits.
  ///
  /// In en, this message translates to:
  /// **'g, kg, mg, ml, l, cl, tsp, tbsp, pinch, drop, piece, tbspoz, pound, cup, pt, qt, gal'**
  String get listUnits;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @supportedLanguage.
  ///
  /// In en, this message translates to:
  /// **'English,French,Your device language (english and french available)'**
  String get supportedLanguage;

  /// No description provided for @askRestart.
  ///
  /// In en, this message translates to:
  /// **'Please restart your application'**
  String get askRestart;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @licence.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get licence;

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get sourceCode;

  /// No description provided for @searchTag.
  ///
  /// In en, this message translates to:
  /// **'Search a tag'**
  String get searchTag;

  /// No description provided for @searchIngred.
  ///
  /// In en, this message translates to:
  /// **'Search an ingredient'**
  String get searchIngred;

  /// No description provided for @searchRecipeName.
  ///
  /// In en, this message translates to:
  /// **'Search a recipe name'**
  String get searchRecipeName;

  /// No description provided for @recipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipes;

  /// No description provided for @searchRecipe.
  ///
  /// In en, this message translates to:
  /// **'Search a recipe'**
  String get searchRecipe;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @quitAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Quit the app?'**
  String get quitAppConfirm;

  /// No description provided for @sourceUrlScrap.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sourceUrlScrap;

  /// No description provided for @errorScrap.
  ///
  /// In en, this message translates to:
  /// **'Error : this URL is not supported'**
  String get errorScrap;

  /// No description provided for @noRecipes.
  ///
  /// In en, this message translates to:
  /// **'No recipes to display.'**
  String get noRecipes;

  /// No description provided for @categoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Category is required.'**
  String get categoryEmpty;

  /// No description provided for @noTitle.
  ///
  /// In en, this message translates to:
  /// **'No title'**
  String get noTitle;

  /// No description provided for @thxContrib.
  ///
  /// In en, this message translates to:
  /// **'Contributors and thanks'**
  String get thxContrib;

  /// No description provided for @dougy147.
  ///
  /// In en, this message translates to:
  /// **'A big thank to dougy147 for his marmiteur library allowing us to retrieve our favorite recipes from the internet!'**
  String get dougy147;

  /// No description provided for @feelFreeContrib.
  ///
  /// In en, this message translates to:
  /// **'Don\'t hesitate to improve this app with your contribution!'**
  String get feelFreeContrib;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact:'**
  String get contact;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report issue'**
  String get reportIssue;

  /// No description provided for @supportMe.
  ///
  /// In en, this message translates to:
  /// **'You can support me by adding a star on my github and/or donate.'**
  String get supportMe;

  /// No description provided for @donate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
