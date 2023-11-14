import 'package:Duet_Classified/helpers/api_helper.dart';
import 'package:Duet_Classified/models/languagePackModel.dart';
import 'package:flutter/cupertino.dart';

import '../helpers/current_user.dart';

class Languages with ChangeNotifier {
  static List<LanguagePackModel> _languagePackModel = [];

  Languages() {
    fetchLanguagePackModel();
  }

  Map<String, String> get selected {
    LanguagePackModel selectedLanguage = _languagePackModel
        .where((x) =>
            x.language.toLowerCase() == CurrentUser.language.toLowerCase())
        .first;
    CurrentUser.textDirection = (selectedLanguage.direction == "ltr")
        ? TextDirection.ltr
        : TextDirection.rtl;
    return selectedLanguage.text;
  }

  String get getLanguageCode {
    LanguagePackModel selectedLanguage = _languagePackModel
        .where((x) =>
            x.language.toLowerCase() == CurrentUser.language.toLowerCase())
        .first;
    return selectedLanguage.languageCode;
  }

  Map<String, String> get messageHashTag {
    LanguagePackModel selectedLanguage = _languagePackModel
        .where((x) =>
            x.language.toLowerCase() == CurrentUser.language.toLowerCase())
        .first;
    return selectedLanguage.hashTags;
  }

  Future fetchLanguagePackModel() async {
    final apiHelper = APIHelper();
    _languagePackModel =
        await apiHelper.fetchLanguagePack() as List<LanguagePackModel>;
  }

  Map<String, String> _english = {
    "Welcome": "Welcome",
    "Welcome log title": "Log in yourself to proceed",
    "Welcomeback": "Welcome Back",
    "By signing up you agree to our Terms & Conditions and Privacy Policy":
        "By signing up you agree to our Terms & Conditions and Privacy Policy",
    "Something went wrong, we are working on it to fix it as soon as possible":
        "Something went wrong, we are working on it to fix it as soon as possible",
    "Enter your email and we'll send you a link to create a new password":
        "Enter your email and we'll send you a link to create a new password",
    "You have cancelled facebook login, please login to continue":
        "You have cancelled facebook login, please login to continue",
    "Looks like owner has not shared his email id":
        "Looks like owner has not shared his email id",
    "You must be logged in to use this feature":
        "You must be logged in to use this feature",
    "Username or email is already occupied":
        "Username or email is already occupied",
    "Please check your internet connection":
        "Please check your internet connection",
    "Login to know more about the seller":
        "Login to know more about the seller",
    "Your offer submitted to the owner": "Your offer submitted to the owner",
    "I am interested in your property": "I am interested in your property",
    "Log in or sign up to continue": "Log in or sign up to continue",
    "What are you looking for?": "What are you looking for?",
    "We can have discussion on": "We can have discussion on",
    "Top Picks in Classifieds": "Top Picks in Classifieds",
    "Seller asking price is": "Seller asking price is",
    "Logged in successfully": "Logged in successfully",
    "RESET YOUR PASSWORD": "RESET YOUR PASSWORD",
    "SIGN UP WITH EMAIL": "SIGN UP WITH EMAIL",
    "Log in with email": "Log in with email",
    "Email or Username": "Email or Username",
    "Email/Username": "Email/Username",
    "Log in or sign up": "Log in or sign up",
    "Make an Offer": "Make an Offer",
    "My Saved Searches": "My Saved Searches",
    "Continue Browsing": "Continue Browsing",
    "Property status": "Property status",
    "Loading countries..": "Loading countries..",
    "Loading states..": "Loading states..",
    "Loading cities..": "Loading cities..",
    "Select country": "Select country",
    "Select state": "Select state",
    "Select city": "Select city",
    "Select language": "Select language",
    "Login required": "Login required",
    "My Favorites": "My Favorites",
    "Privacy Policy": "Privacy Policy",
    "Terms & Condition": "Terms & Condition",
    "Forgot Password": "Forgot Password",
    "Type a message": "Type a message",
    "Send email…": "Send email…",
    "Light Usage": "Light Usage",
    "Share using": "Share using",
    "My Account": "My Account",
    "Enter text": "Enter text",
    "Posted By": "Posted By",
    "Language": "Language",
    "Confirm": "Confirm",
    "Regards": "Regards",
    "Classifieds": "Classifieds",
    "Age": "Age",
    "Usage": "Usage",
    "Condition": "Condition",
    "SMS": "SMS",
    "Call": "Call",
    "Chat": "My Chat",
    "Map": "Map",
    "Excellent": "Excellent",
    "Search": "Search",
    "Cancel": "Cancel",
    "Login": "Login",
    "LOG IN": "LOG IN",
    "Signup": "Signup",
    "Sign In": "Sign In",
    "Sign Out": "Sign Out",
    "Email": "Email",
    "Hidden": "Hidden",
    "Password": "Password",
    "Show": "Show",
    "Hide": "Hide",
    "My Ads": "My Ads",
    "Create Ad": "Create Ad",
    "Setting": "Setting",
    "Country": "Country",
    "STATE": "STATE",
    "City": "City",
    "Support": "Support",
    "Username": "Username",
    "Phone": "Phone",
    "Description": "Description",
    "Location": "Location",
    "Please enter your full name": "Please enter your full name",
    "Username can contain only Alphanumeric characters":
        "Username can contain only Alphanumeric characters",
    "Please enter minimum 6 characters of Username":
        "Please enter minimum 6 characters of Username",
    "Please enter correct Email id": "Please enter correct Email id",
    "Please enter minimum 6 characters of Password":
        "Please enter minimum 6 characters of Password",
    "Offer from": "Offer from",
    "is interested to buy": "is interested to buy",
    "at": "at",
    "Sending…": "Sending…",
    "All": "All",
    "Search Result": "Search Result",
    "No products found, please refine your search":
        "No products found, please refine your search",
    "Searching…": "Searching…",
    "Continue last Search": "Continue last Search",
    "It seems you have not started your chat yet":
        "It seems you have not started your chat yet",
    "My Notifications": "My Notifications",
    "You have not received any notification":
        "You have not received any notification",
    "What are you listing?": "What are you listing?",
    "Choose the category that your ad fits into.":
        "Choose the category that your ad fits into.",
    "Choose sub category that your ad fits into.":
        "Choose sub category that your ad fits into.",
    "Select sub category": "Select sub category",
    "Enter title": "Enter title",
    "First, enter a short title to describe your listing":
        "First, enter a short title to describe your listing",
    "add_photo": "add_photo",
    "OK": "OK",
    "Please enable location service to continue. We require it to get your current Ad location":
        "Please enable location service to continue. We require it to get your current Ad location",
    "Place an Ad": "Place an Ad",
    "Upload Details": "Upload Details",
    "Submit Details": "Submit Details",
    "Please wait..": "Please wait..",
    "Filter by": "Filter by",
    "Enter your keyword to search": "Enter your keyword to search",
    "Congratulations!! You have successfully posted":
        "Congratulations!! You have successfully posted",
    "Tap on map to Pin Location": "Tap on map to Pin Location",
    "Additional Info": "Additional Info",
    "Newest to Oldest": "Newest to Oldest",
    "Oldest to Newest": "Oldest to Newest",
    "Price Highest to Lowest": "Price Highest to Lowest",
    "Price Lowest to Highest": "Price Lowest to Highest",
    "Enter Keyword": "Enter Keyword",
    "Please wait, map is getting initialized":
        "Please wait, map is getting initialized",
    "Phone number": "Phone number",
    "Price": "Price",
    "Filter by Keyword": "Filter by Keyword",
    "Some thing went wrong, please restart the upload process":
        "Some thing went wrong, please restart the upload process",
    "Salary": "Salary",
    "Post": "Post",
    "Hide phone number": "Hide phone number",
    "Negotiable": "Negotiable",
    "Sort by": "Sort by",
    "Pin Location": "Pin Location",
    "Categories": "Categories",
    "Featured and Urgent Ads": "Featured and Urgent Ads",
    "Featured": "Featured",
    "Urgent": "Urgent",
    "Choose your language": "Choose your language",
    "Forget your password?": "Forget your password?",
    "Log out": "Log out",
    "Settings": "Settings",
    "State": "State",
    "Terms & Conditions": "Terms & Conditions",
    "Offline": "Offline",
    "Search…": "Search…",
    "CONTINUE": "CONTINUE",
    "This will be listed in": "This will be listed in",
    "First name": "First name",
    "Sign up to": "Sign up to",
    "SIGN UP": "SIGN UP",
    "ADD PHOTO": "ADD PHOTO",
    "Add More Info": "Add More Info",
    "Posted by": "Posted by",
    "Professional": "Professional",
    "MAKE AN OFFER": "MAKE AN OFFER",
    "Are you sure you want to log out": "Are you sure you want to log out",
    "YES": "YES",
    "NO": "NO",
    "Enter message": "Enter message",
    "Upgrade To Premium": "Upgrade To Premium",
    "Awesome!! You are just one step away from Premium":
        "Awesome!! You are just one step away from Premium",
    "Your all posted ads will become premium for 30 days":
        "Your all posted ads will become premium for 30 days",
    "All Ads Premium": "All Ads Premium",
    "Your issues will be solved at the earliest":
        "Your issues will be solved at the earliest",
    "Priority Support": "Priority Support",
    "No third party ads. Ex Google Ads": "No third party ads. Ex Google Ads",
    "Ads Free": "Ads Free",
    "Please select at least one premium feature to continue, click + button to add":
        "Please select at least one premium feature to continue, click + button to add",
    "Featured ads attract higher-quality viewer and are displayed prominently in the Featured ads section home page":
        "Featured ads attract higher-quality viewer and are displayed prominently in the Featured ads section home page",
    "Make your ad highlighted with border in listing search result page. Easy to focus":
        "Make your ad highlighted with border in listing search result page. Easy to focus",
    "Make your ad stand out and let viewer know that your advertise is time sensitive":
        "Make your ad stand out and let viewer know that your advertise is time sensitive",
    "Highlighted": "Highlighted",
    "Total price": "Total price",
    "Pay Using": "Pay Using",
    "Please enter the card details to proceed":
        "Please enter the card details to proceed",
    "Payment Successful": "Payment Successful",
    "Payment Failure": "Payment Failure",
    "Congratulations your payment is successful":
        "Congratulations your payment is successful",
    "Unfortunately your payment is failed, please retry":
        "Unfortunately your payment is failed, please retry",
    "Package": "Package",
    "Pending": "Pending",
    "Premium Membership": "Premium Membership",
    "Successfully Upgraded": "Successfully Upgraded",
    "Ad Post Limit": "Ad Post Limit",
    "Ad Expiry in": "Ad Expiry in",
    "Featured Ad fee": "Featured Ad fee",
    "Urgent Ad fee": "Urgent Ad fee",
    "Highlight Ad fee": "Highlight Ad fee",
    "Top in search results and category": "Top in search results and category",
    "Show ad on home page premium ad section":
        "Show ad on home page premium ad section",
    "Show ad on home page search result": "Show ad on home page search result",
    "Your Current Plan": "Your Current Plan",
    "for": "for",
    "days": "days",
    "yes": "yes",
    "signmobilenumber": "Sign in with Mobile Number",
    "createaccount": "Create Account",
    "mobilenumber": "Mobile Number",
    "signinwithgoogle": "Sign in With Google",
    "signinwithfacebook": "Sign in With Facebook",
    "signinwithmobilenumber": "Sign in With Mobile Number",
    "continuewithmobilenumber": "Continue With Mobile Number",
    "enteryourphonenumber": "Enter Your Phon Number",
    "wewillsendotptomobilenumber":
        "We will send One Time Password(OTP) on this mobile number",
    "sendotp": "SEND OTP",
    "verifyproceed": "VERIFY & PROCEED",
    "verifymobile": "Verify Mobile Number",
    "wesentaverificationcode": "We sent a verification code to",
    "entercodebelow": "Enter the Code below boxes",
    "dontreceivecode": "Don't receive code?",
    "resendcode": "Resend Code",
    "Invalid mobile number": "Invalid mobile number",
    "Fill TextBox": "Fill TextBoxes",
    "Wrong OTP": "Wrong OTP",
    "Transaction": "Transaction",
    "Expired Ads": "Expired Ads",
    "Share": "Share",
    "Rate Us": "Rate Us",
    "Recommended Ads for You": "Recommended Ads for You",
    "Choose Location": "Choose Location"
  };

  Map<String, String> _arabic = {
    "Welcome": "أهلا بك",
    "Welcome log title": "سجل دخولك بنفسك للمضي قدما",
    "Welcomeback": "مرحبًا بعودتك",
    " Please enable location service to continue. We require it to get your current Ad location":
        "يرجى تمكين خدمة الموقع للمتابعة. نطلبها للحصول على موقعك الإعلاني الحالي",
    "By signing up you agree to our Terms & Conditions and Privacy Policy":
        "بالتسجيل ، أنت توافق على الشروط والأحكام وسياسة الخصوصية الخاصة بنا",
    "Something went wrong, we are working on it to fix it as soon as possible":
        "حدث خطأ ما ، نحن نعمل عليه لإصلاحه في أسرع وقت ممكن",
    "Enter your email and we\"ll send you a link to create a new password":
        "أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإنشاء كلمة مرور جديدة",
    "You have cancelled facebook login, please login to continue":
        "أدخل بريدك الإلكتروني وسنرسل لك رابطًا",
    "Some thing went wrong, please restart the upload process":
        "حدث خطأ ما ، يرجى إعادة تشغيل عملية التحميل",
    "First, enter a short title to describe your listing":
        "أولاً ، أدخل عنوانًا قصيرًا لوصف قائمتك",
    "Username can contain only Alphanumeric characters":
        "يمكن أن يحتوي اسم المستخدم على أحرف أبجدية رقمية فقط",
    "Congratulations!! You have successfully posted":
        "تهانينا!! لقد نشرت بنجاح",
    "Please enter minimum 6 characters of Username":
        "يرجى إدخال 6 أحرف على الأقل من اسم المستخدم",
    "Please enter minimum 6 characters of Password":
        "الرجاء إدخال 6 أحرف على الأقل من كلمة المرور",
    "No products found, please refine your search":
        "لم يتم العثور على منتجات ، يرجى تحسين بحثك",
    "It seems you have not started your chat yet":
        "يبدو أنك لم تبدأ محادثتك بعد",
    "Choose the category that your ad fits into.":
        "اختر الفئة التي يناسبها إعلانك.",
    "Choose sub category that your ad fits into.":
        "اختر فئة فرعية يلائمها إعلانك.",
    "Looks like owner has not shared his email id":
        "يبدو أن المالك لم يشارك معرف بريده الإلكتروني",
    "You must be logged in to use this feature":
        "يجب عليك تسجيل الدخول لاستخدام هذه الميزة",
    "You have not received any notification": "لم تستلم أي إشعار",
    "Please wait, map is getting initialized":
        "الرجاء الانتظار ، يتم تهيئة الخريطة",
    "Username or email is already occupied":
        "اسم المستخدم أو البريد الإلكتروني مشغول بالفعل",
    "Please check your internet connection":
        "الرجاء التحقق من اتصال الانترنت الخاص بك",
    "Login to know more about the seller":
        "تسجيل الدخول لمعرفة المزيد عن البائع",
    "Your offer submitted to the owner": "عرضك المقدم إلى المالك",
    "I am interested in your property": "أنا مهتم في الممتلكات الخاصة بك",
    "Log in or sign up to continue": "تسجيل الدخول أو التسجيل للمتابعة",
    "Please enter correct Email id":
        "الرجاء إدخال معرف البريد الإلكتروني الصحيح",
    "Please enter your full name": "من فضلك ادخل اسمك الكامل",
    "Enter your keyword to search": "أدخل كلمتك الرئيسية للبحث",
    "Tap on map to Pin Location": "اضغط على الخريطة لتحديد الموقع",
    "Price Highest to Lowest": "السعر من الأعلى إلى الأدنى",
    "Price Lowest to Highest": "السعر من الأقل إلى الأعلى",
    "What are you looking for?": "عما تبحث؟",
    "We can have discussion on": "يمكننا مناقشة",
    "Top Picks in Classifieds": "أعلى اللقطات في الإعلانات المبوبة",
    "Seller asking price is": "البائع سعر الطلب هو",
    "Logged in successfully": "تم تسجيل الدخول بنجاح",
    "RESET YOUR PASSWORD": "اعد ضبط كلمه السر",
    "SIGN UP WITH EMAIL": "سجل عن طريق البريد الإلكتروني",
    "Log in with email": "تسجيل الدخول مع البريد الإلكتروني",
    "Email or Username": "البريد الإلكتروني أو اسم المستخدم",
    "Email/Username": " المستخدم",
    "Log in or sign up": "تسجيل الدخول أو الاشتراك",
    "Make an Offer": "تقديم عرض",
    "My Saved Searches": "عمليات البحث المحفوظة الخاصة بي",
    "is interested to buy": "مهتمة بالشراء",
    "Continue last Search": "مواصلة البحث الماضي",
    "What are you listing?": "ما الذي تدرجه؟",
    "Select sub category": "اختر الفئة الفرعية",
    "Newest to Oldest": "الأحدث إلى الأقدم",
    "Oldest to Newest": "من الأقدم إلى الأحدث",
    "Filter by Keyword": "تصفية حسب الكلمات الرئيسية",
    "Hide phone number": "إخفاء رقم الهاتف",
    "Place an Ad": "ضع إعلانا",
    "My Notifications": "الإشعارات الخاصة بي",
    "Continue Browsing": "تابع التصفح",
    "Property status": "حالة الملكية",
    "Loading countries..": "تحميل الدول ..",
    "Loading states..": "تحميل الدول ..",
    "Loading cities..": "تحميل المدن ..",
    "Select country": "حدد الدولة",
    "Select state": "اختر ولايه",
    "Select city": "اختر مدينة",
    "Select language": "اختار اللغة",
    "Login required": "تسجيل الدخول مطلوب",
    "My Favorites": "مفضلتي",
    "Privacy Policy": "سياسة خاصة",
    "Terms & Condition": "الشروط والأحكام",
    "Forgot Password": "هل نسيت كلمة المرور",
    "Type a message": "اكتب رسالة",
    "Send email…": "ارسل بريد الكتروني…",
    "Light Usage": "استخدام الضوء",
    "Share using": "مشاركة باستخدام",
    "My Account": "حسابي",
    "Enter text": "أدخل النص",
    "Posted By": "منشور من طرف",
    "Upload Details": "تحميل التفاصيل",
    "Submit Details": "تقديم التفاصيل",
    "Please wait..": "ارجوك انتظر..",
    "Pin Location": "دبوس الموقع",
    "Additional Info": "معلومات إضافية",
    "Enter Keyword": "أدخل الكلمة المفتاحية",
    "Phone number": "رقم الهاتف",
    "Search Result": "نتيجة البحث",
    "Offer from": "عرض من",
    "Enter title": "أدخل العنوان",
    "Filter by": "مصنف بواسطة",
    "Sort by": "ترتيب حسب",
    "Description": "وصف",
    "Location": "موقعك",
    "Negotiable": "قابل للتفاوض",
    "Categories": "الاقسام",
    "add_photo": "إضافة صورة",
    "Searching…": "البحث ...",
    "Sending…": "إرسال…",
    "Language": "لغة",
    "Confirm": "تؤكد",
    "Regards": "مع تحياتي",
    "Classifieds": "إعلانات مبوبة",
    "Condition": "شرط",
    "Usage": "استعمال",
    "My Ads": "إعلاناتي",
    "Sign In": "تسجيل الدخول",
    "LOG IN": "تسجيل الدخول",
    "Sign Out": "خروج",
    "Excellent": "ممتاز",
    "Search": "بحث",
    "Cancel": "إلغاء",
    "Login": "تسجيل الدخول",
    "Signup": "سجل",
    "Email": "البريد الإلكتروني",
    "Hidden": "مخفي",
    "Password": "كلمه السر",
    "Setting": "ضبط",
    "Country": "بلد",
    "STATE": "حالة",
    "City": "مدينة",
    "Support": "الدعم",
    "Username": "اسم المستخدم",
    "Phone": "هاتف",
    "Price": "السعر",
    "Salary": "راتب",
    "Show": "تبين",
    "Hide": "إخفاء",
    "Post": "بريد",
    "Chat": "دردشة",
    "Call": "مكالمة",
    "SMS": "رسالة قصيرة",
    "Age": "عمر",
    "Map": "خريطة",
    "All": "الكل",
    "OK": "حسنا",
    "at": "في",
    "Featured and Urgent Ads": "إعلانات مميزة وعاجلة",
    "Featured": "متميز",
    "Urgent": "العاجلة",
    "Choose your language": "اختر لغتك",
    "Forget your password?": "نسيت كلمة المرور؟",
    "Log out": "الخروج",
    "Settings": "الإعدادات",
    "State": "حالة",
    "Terms & Conditions": "البنود و الظروف",
    "Offline": "غير متصل على الانترنت",
    "Search…": "بحث",
    "CONTINUE": "استمر",
    "This will be listed in": "سيتم سرد هذا في",
    "First name": "الاسم الاول",
    "Sign up to": "التوقيع على",
    "SIGN UP": "سجل",
    "ADD PHOTO": "إضافة صورة",
    "Add More Info": "إضافة المزيد من المعلومات",
    "Posted by": "منشور من طرف",
    "Professional": "المحترفين",
    "MAKE AN OFFER": "تقديم عرض",
    "Are you sure you want to log out": "هل أنت متأكد أنك تريد تسجيل الخروج",
    "YES": "نعم فعلا",
    "NO": "لا",
    "Enter message": "أدخل رسالة",
    "Upgrade To Premium": "الترقية إلى بريميوم",
    "Awesome!! You are just one step away from Premium":
        "مدهش!! أنت على بعد خطوة واحدة فقط من الممتازة",
    "Your all posted ads will become premium for 30 days":
        "ستصبح جميع الإعلانات المنشورة متميزة لمدة 30 يومًا",
    "All Ads Premium": "جميع الإعلانات بريميوم",
    "Your issues will be solved at the earliest":
        "سيتم حل مشاكلك في أقرب وقت ممكن",
    "Priority Support": "دعم الأولوية",
    "No third party ads. Ex Google Ads":
        "لا إعلانات طرف ثالث. السابقين إعلانات جوجل",
    "Ads Free": "إعلانات مجانية",
    "Please select at least one premium feature to continue, click + button to add":
        "يرجى تحديد ميزة واحدة على الأقل للمتابعة ، انقر على زر + للإضافة",
    "Featured ads attract higher-quality viewer and are displayed prominently in the Featured ads section home page":
        "الإعلانات المميزة تجذب المشاهد عالي الجودة ويتم عرضها بشكل بارز في الصفحة الرئيسية لقسم الإعلانات المميزة",
    "Make your ad highlighted with border in listing search result page. Easy to focus":
        "اجعل إعلانك مميّزًا بحدود في صفحة نتائج بحث القائمة. من السهل التركيز",
    "Make your ad stand out and let viewer know that your advertise is time sensitive":
        "اجعل إعلانك بارزًا وأعلم المشاهد أن الإعلان حساس للوقت",
    "Highlighted": "سلط الضوء",
    "Total price": "السعر الكلي",
    "Pay Using": "الدفع باستخدام",
    "Please enter the card details to proceed":
        "الرجاء إدخال تفاصيل البطاقة للمتابعة",
    "Payment Successful": "الدفع الناجح",
    "Payment Failure": "فشل الدفع",
    "Congratulations your payment is successful": "مبروك الدفع بنجاح",
    "Unfortunately your payment is failed, please retry":
        "لسوء الحظ ، أخفق الدفع ، يرجى إعادة المحاولة",
    "Package": "صفقة",
    "Pending": "قيد الانتظار",
    "Premium Membership": "عضوية مميزة",
    "Successfully Upgraded": "تمت ترقيته بنجاح",
    "Ad Post Limit": " حد مشاركة الإعلان",
    "Ad Expiry in": " انتهاء صلاحية الإعلان في",
    "Featured Ad fee": " رسوم الإعلانات المميزة",
    "Urgent Ad fee": " رسوم الإعلانات العاجلة",
    "Highlight Ad fee": " تسليط الضوء على رسوم الإعلان",
    "Top in search results and category": "أعلى في نتائج البحث والفئة",
    "Show ad on home page premium ad section":
        "عرض الإعلان على قسم الإعلانات المميزة للصفحة الرئيسية",
    "Show ad on home page search result":
        "عرض الإعلان على نتائج البحث في الصفحة الرئيسية",
    "Your Current Plan": "خطتك الحالية",
    "for": "إلى عن على",
    "days": "أيام",
    "yes": "نعم",
    "signmobilenumber": "تسجيل الدخول باستخدام رقم الهاتف المحمول",
    "createaccount": "إنشاء حساب",
    "mobilenumber": "رقم الهاتف المحمول",
    "signinwithgoogle": "الدخول مع جوجل",
    "signinwithfacebook": "قم بتسجيل الدخول باستخدام الفيسبوك",
    "signinwithmobilenumber": "تسجيل الدخول باستخدام رقم الهاتف المحمول",
    "continuewithmobilenumber": "تواصل مع رقم الهاتف المحمول",
    "enteryourphonenumber": "أدخل رقم الهاتف الخاص بك",
    "wewillsendotptomobilenumber":
        "سنرسل كلمة مرور لمرة واحدة على رقم الهاتف هذا",
    "sendotp": "إرسال OTP",
    "verifyproceed": "التحقق والمتابعة",
    "verifymobile": "تحقق من رقم الهاتف المحمول",
    "wesentaverificationcode": "أرسلنا رمز التحقق إلى",
    "entercodebelow": "أدخل الكود أدناه المربعات",
    "dontreceivecode": "لا تتلقى رمز؟",
    "resendcode": "أعد إرسال الرمز",
    "Invalid mobile number": "رقم الجوال غير صالح",
    "Fill TextBox": "املأ مربعات النص",
    "Wrong OTP": "OTP خاطئ",
    "Crete Ad": "أعلن",
    "Transaction": "عملية",
    "Expired Ads": "إعلانات منتهية الصلاحية",
    "Share": "يشارك",
    "Rate Us": "قيمنا",
    "Recommended Ads for You": "الإعلانات الموصى بها لك",
    "Choose Location": "اختيار موقع"
  };

  Map<String, String> _french = {
    "Welcome": " Bienvenue",
    "Welcome log title": "Connectez-vous pour continuer",
    "Welcomeback": "content de te revoir",
    "By signing up you agree to our Terms & Conditions and Privacy Policy":
        "En vous inscrivant, vous acceptez nos Conditions d'utilisation et notre politique de confidentialité",
    "Something went wrong, we are working on it to fix it as soon as possible":
        "Une erreur s'est produite, nous y travaillons pour le réparer le plus rapidement possible",
    "Enter your email and we\"ll send you a link to create a new password":
        "Entrez votre email et nous vous enverrons un lien pour créer un nouveau mot de passe",
    "You have cancelled facebook login, please login to continue":
        "Vous avez annulé la connexion à Facebook, veuillez vous connecter pour continuer",
    "Looks like owner has not shared his email id":
        "On dirait que le propriétaire n'a pas partagé son identifiant de messagerie",
    "You must be logged in to use this feature":
        "Vous devez être connecté pour utiliser cette fonctionnalité",
    "Username or email is already occupied":
        "Le nom d'utilisateur ou l'email est déjà occupé",
    "Please check your internet connection":
        "Veuillez vérifier votre connexion Internet",
    "Login to know more about the seller":
        "Connectez-vous pour en savoir plus sur le vendeur",
    "Your offer submitted to the owner": "Votre offre soumise au propriétaire",
    "I am interested in your property": "Je suis intéressé par votre bien",
    "Log in or sign up to continue":
        "Connectez-vous ou inscrivez-vous pour continuer",
    "What are you looking for?": "Que cherchez-vous?",
    "We can have discussion on": "Nous pouvons discuter",
    "Top Picks in Classifieds": "Meilleurs choix dans les annonces",
    "Seller asking price is": "Le prix demandé par le vendeur est",
    "Logged in successfully": "Connecté avec succès",
    "RESET YOUR PASSWORD": "RESET YOUR PASSWORD",
    "SIGN UP WITH EMAIL": "INSCRIVEZ-VOUS AVEC UN EMAIL",
    "Log in with email": "Se connecter avec un email",
    "Email or Username": "Email ou nom d'utilisateur",
    "Email/Username": "Nom d'utilisateur",
    "Log in or sign up": "Connectez-vous ou inscrivez-vous",
    "Make an Offer": "Faire une offre",
    "My Saved Searches": "Mes recherches sauvegardées",
    "Continue Browsing": "Continuer la navigation",
    "Property status": "Statut de la propriété",
    "Loading countries ..": "Chargement des pays ..",
    "Loading states ..": "Chargement des états ..",
    "Loading cities ..": "Chargement des villes ..",
    "Select country": "Sélectionnez un pays",
    "Select state": "Select state",
    "Select city": "Choisir la ville",
    "Select language": "Select language",
    "Login required": "Connexion requise",
    "My Favorites": "Mes favoris",
    "Privacy Policy": "Politique de confidentialité",
    "Terms & Condition": "Termes & Conditions",
    "Forgot Password": "Forgot Password",
    "Type a message": "Tapez un message",
    "Send email…": "Envoyer un email ...",
    "Light Usage": "Utilisation légère",
    "Share using": "Partager avec",
    "My Account": "Mon compte",
    "Enter text": "Enter text",
    "Posted By": "Publié par",
    "My Ads": "Mes annonces",
    "Sign In": "Sign In",
    "Sign Out": "Déconnexion",
    "LOG IN": "CONNEXION",
    "Login": "Connexion",
    "Signup": "Inscription",
    "Language": "Langue",
    "Confirm": "Confirmer",
    "Regards": "Cordialement",
    "Classifieds": "Classifieds",
    "Age": "Age",
    "Usage": "Utilisation",
    "Condition": "Condition",
    "SMS": "SMS",
    "Call": "Call",
    "Chat": "Chat",
    "Map": "Carte",
    "Excellent": "Excellent",
    "Search": "Chercher",
    "Cancel": "Annuler",
    "Email": "Email",
    "Hidden": "caché",
    "Password": "Mot de passe",
    "Show": "montre",
    "Hide": "Cacher",
    "Setting": "Setting",
    "Pays": "Pays",
    "STATE": "STATE",
    "City": "Ville",
    "Support": "Support",
    "Username": "Nom d'utilisateur",
    "Phone": "Téléphone",
    "Description": "Description",
    "Location": "Lieu",
    "Please enter your full name": "S'il vous plaît entrer votre nom complet",
    "Username can contain only Alphanumeric characters":
        "Le nom d'utilisateur ne peut contenir que des caractères alphanumériques",
    "Please enter minimum 6 characters of Username":
        "Merci d'entrer au moins 6 caractères de nom d'utilisateur",
    "Please enter correct Email id":
        "S'il vous plaît entrer l'id email correct",
    "Please enter minimum 6 characters of Password":
        "Veuillez entrer un minimum de 6 caractères de mot de passe",
    "Offer from": "Offre de",
    "is interested to buy": "est intéressé à acheter",
    "at": "à",
    "Sending…": "Envoi…",
    "All": "Tout",
    "Search Result": "Résultat de la recherche",
    "No products found, please refine your search":
        "Aucun produit trouvé, veuillez affiner votre recherche",
    "Searching…": "Recherche…",
    "Continue last Search": "Continuer la dernière recherche",
    "It seems you have not started your chat yet":
        "Il semble que tu n'as pas encore commencé ton chat",
    "My Notifications": "mes notifications",
    "You have not received any notification":
        "Vous n'avez reçu aucune notification",
    "What are you listing?": "Qu'est-ce que vous listez?",
    "Choose the category that your ad fits into.":
        "Choisissez la catégorie de votre annonce.",
    "Choose sub category that your ad fits into.":
        "Choisissez la sous-catégorie à laquelle votre annonce appartient.",
    "Select sub category": "Sélectionner une sous catégorie",
    "Enter title": "Entrer titre",
    "First, enter a short title to describe your listing":
        "Tout d'abord, entrez un titre court pour décrire votre annonce",
    "add_photo": "ajouter une photo",
    "OK": "D'accord",
    "Please enable location service to continue. We require it to get your current Ad location":
        "Veuillez activer le service de localisation pour continuer. Nous en avons besoin pour obtenir votre emplacement de l'annonce actuelle",
    "Place an Ad": "Passer une annonce",
    "Upload Details": "Détails du téléchargement",
    "Submit Details": "Soumettre les détails",
    "Please wait..": "S'il vous plaît attendez ..",
    "Filter by": "Filtrer par",
    "Enter your keyword to search": "Entrez votre mot-clé à rechercher",
    "Congratulations!! You have successfully posted":
        "Félicitations !! Vous avez posté avec succès",
    "Tap on map to Pin Location":
        "Appuyez sur la carte pour l'emplacement de la localisation",
    "Additional Info": "Informations complémentaires",
    "Newest to Oldest": "Du plus récent au plus ancien",
    "Oldest to Newest": "Du plus ancien au plus récent",
    "Price Highest to Lowest": "Prix le plus élevé au plus bas",
    "Price Lowest to Highest": "Prix le plus bas au plus élevé",
    "Enter Keyword": "Entrer mot clé",
    "Please wait, map is getting initialized":
        "Veuillez patienter, la carte est en cours d'initialisation",
    "Phone number": "Numéro de téléphone",
    "Price": "Prix",
    "Filter by Keyword": "Filtrer par mot clé",
    "Some thing went wrong, please restart the upload process":
        "Une erreur s'est produite, veuillez redémarrer le processus de téléchargement",
    "Salary": "Un salaire",
    "Post": "Poster",
    "Hide phone number": "Masquer le numéro de téléphone",
    "Negotiable": "Négociable",
    "Sort by": "Trier par",
    "Pin Location": "Emplacement Pin",
    "Categories": "Les catégories",
    "Featured and Urgent Ads": "Annonces en vedette et urgentes",
    "Featured": "En vedette",
    "Urgent": "Urgent",
    "Choose your language": "Choisissez votre langue",
    "Forget your password?": "Mot de passe oublié?",
    "Log out": "Connectez - Out",
    "Settings": "Réglages",
    "State": "Etat",
    "Terms & Conditions": "termes et conditions",
    "Offline": "Hors ligne",
    "Search…": "Chercher…",
    "CONTINUE": "CONTINUER",
    "This will be listed in": "Ce sera répertorié dans",
    "First name": "Prénom",
    "Sign up to": "Inscrivez-vous pour",
    "SIGN UP": "S'INSCRIRE",
    "ADD PHOTO": "AJOUTER UNE PHOTO",
    "Add More Info": "Ajouter plus d'infos",
    "Posted by": "posté par",
    "Professional": "Professionnel",
    "MAKE AN OFFER": "FAIRE UNE OFFRE",
    "Are you sure you want to log out":
        "Êtes-vous sûr de vouloir vous déconnecter",
    "YES": "OUI",
    "NO": "NON",
    "Enter message": "Entrez le message",
    "Upgrade To Premium": "Passer à la version premium",
    "Awesome!! You are just one step away from Premium":
        "Impressionnant!! Vous n'êtes plus qu'à une étape de Premium",
    "Your all posted ads will become premium for 30 days":
        "Toutes vos annonces publiées deviendront premium pendant 30 jours",
    "All Ads Premium": "Toutes les annonces Premium",
    "Your issues will be solved at the earliest":
        "Vos problèmes seront résolus au plus tôt",
    "Priority Support": "Support prioritaire",
    "No third party ads. Ex Google Ads":
        "Pas d'annonces tierces. Ex Google Ads",
    "Ads Free": "Annonces gratuites",
    "Please select at least one premium feature to continue, click + button to add":
        "Veuillez sélectionner au moins une fonctionnalité premium pour continuer, cliquez sur le bouton + pour ajouter.",
    "Featured ads attract higher-quality viewer and are displayed prominently in the Featured ads section home page":
        "Les annonces présentées attirent des internautes de qualité supérieure et sont bien visibles sur la page d'accueil de la section Annonces sélectionnée.",
    "Make your ad highlighted with border in listing search result page. Easy to focus":
        "Mettez votre annonce en surbrillance avec une bordure dans la page de résultats de recherche. Facile à se concentrer",
    "Make your ad stand out and let viewer know that your advertise is time sensitive":
        "Faites en sorte que votre annonce se démarque et faites savoir au spectateur que votre annonce est sensible au temps",
    "Highlighted": "Souligné",
    "Total price": "Prix total",
    "Pay Using": "Payer en utilisant",
    "Please enter the card details to proceed":
        "S'il vous plaît entrer les détails de la carte pour continuer",
    "Payment Successful": "Paiement réussi",
    "Payment Failure": "Échec du paiement",
    "Congratulations your payment is successful":
        "Félicitations, votre paiement est réussi",
    "Unfortunately your payment is failed, please retry":
        "Malheureusement, votre paiement a échoué, veuillez réessayer.",
    "Package": "Paquet",
    "Pending": "En attente",
    "Premium Membership": "Adhésion Premium",
    "Successfully Upgraded": "Mise à niveau réussie",
    "Ad Post Limit": "Limite de publication d'annonces",
    "Ad Expiry in": "Expiration de l'annonce dans",
    "Featured Ad fee": "Frais d'annonce en vedette",
    "Urgent Ad fee": "Frais d'annonce urgente",
    "Highlight Ad fee": "HMettre en évidence les frais de publicité",
    "Top in search results and category":
        "Top des résultats de recherche et catégorie",
    "Show ad on home page premium ad section":
        "Afficher l'annonce sur la page d'annonces premium de la page d'accueil",
    "Show ad on home page search result":
        "Afficher l'annonce sur le résultat de la recherche sur la page d'accueil",
    "Your Current Plan": "Votre plan actuel",
    "for": "pour",
    "days": "journées",
    "yes": "Oui",
    "createaccount": "créer un compte",
    "signmobilenumber": "Connectez-vous avec un numéro de téléphone portable",
    "mobilenumber": "numéro de portable",
    "signinwithgoogle": "se connecter avec google",
    "signinwithfacebook": "Connectez-vous avec Facebook",
    "signinwithmobilenumber":
        "Connectez-vous avec un numéro de téléphone portable",
    "continuewithmobilenumber": "Continuer avec le numéro de mobile",
    "enteryourphonenumber": "Entrez votre numéro de téléphone",
    "wewillsendotptomobilenumber":
        "Nous enverrons un mot de passe à usage unique sur ce numéro de téléphone",
    "sendotp": "ENVOYER OTP",
    "verifyproceed": "VÉRIFIER ET CONTINUER",
    "verifymobile": "Vérifier le numéro de mobile",
    "wesentaverificationcode": "Nous avons envoyé un code de vérification à ",
    "entercodebelow": "Entrez le code ci-dessous",
    "dontreceivecode": "Vous ne recevez pas de code ?",
    "resendcode": "Renvoyer le code",
    "Invalid mobile number": "Numéro de portable invalide",
    "Fill TextBox": "Remplir les zones de texte",
    "Wrong OTP": "Mauvais OTP",
    "Crete Ad": "Créer une publicité",
    "Transaction": "Transaction",
    "Expired Ads": "Annonces expirées",
    "Share": "Partager",
    "Rate Us": "Évaluez nous",
    "Recommended Ads for You": "Annonces recommandées pour vous",
    "Choose Location": "Choisissez l'emplacement"
  };
}
