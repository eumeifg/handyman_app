/// DO NOT CHANGE THIS PACKAGE NAME
const APP_PACKAGE_NAME = "com.iqonic.provider";

//region Configs
const DECIMAL_POINT = 2;
const PER_PAGE_ITEM = 25;
const PER_PAGE_ITEM_ALL = 'all';
const PLAN_REMAINING_DAYS = 15;
const LABEL_TEXT_SIZE = 16;
//endregion

// region For Stripe Payment
const STRIPE_CURRENCY_CODE = 'INR';
//endregion

//region Commission Types
const COMMISSION_TYPE_PERCENT = 'percent';
const COMMISSION_TYPE_FIXED = 'fixed';
//endregion

//region Discount Type
const DISCOUNT_TYPE_FIXED = 'fixed';
//endregion

//region LiveStream Keys
const LIVESTREAM_TOKEN = 'tokenStream';
const LIVESTREAM_UPDATE_BOOKINGS = 'LiveStreamUpdateBookings';
const LIVESTREAM_HANDY_BOARD = 'HandyBoardStream';
const LIVESTREAM_HANDYMAN_ALL_BOOKING = "handymanAllBooking";
const LIVESTREAM_PROVIDER_ALL_BOOKING = "providerAllBooking";
const LIVESTREAM_START_TIMER = "startTimer";
const LIVESTREAM_PAUSE_TIMER = "pauseTimer";
//endregion

//region Theme Mode Type
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;
//endregion

//region One signal Tag
const ONESIGNAL_TAG_KEY = 'appType';
const ONESIGNAL_TAG_PROVIDER_VALUE = 'providerApp';
const ONESIGNAL_TAG_HANDYMAN_VALUE = 'handymanApp';
//endregion

// region JOB REQUEST STATUS
const JOB_REQUEST_STATUS_REQUESTED = "requested";
const JOB_REQUEST_STATUS_ACCEPTED = "accepted";
// endregion

const BOOKING_TYPE_USER_POST_JOB = 'user_post_job';
const BOOKING_TYPE_SERVICE = 'service';

const BOOKING_SAVE_FORMAT = "yyyy-MM-dd kk:mm:ss";

//region SharedPreferences Keys
const IS_FIRST_TIME = 'IsFirstTime';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_TESTER = 'IS_TESTER';
const USER_ID = 'USER_ID';
const USER_TYPE = 'USER_TYPE';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_PASSWORD = 'USER_PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_REMEMBERED = "IS_REMEMBERED";
const TOKEN = 'TOKEN';
const USERNAME = 'USERNAME';
const DISPLAY_NAME = 'DISPLAY_NAME';
const CONTACT_NUMBER = 'CONTACT_NUMBER';
const COUNTRY_ID = 'COUNTRY_ID';
const STATE_ID = 'STATE_ID';
const CITY_ID = 'CITY_ID';
const STATUS = 'STATUS';
const ADDRESS = 'ADDRESS';
const PLAYERID = 'PLAYERID';
const UID = 'UID';
const SERVICE_ADDRESS_ID = 'SERVICE_ADDRESS_ID';
const PROVIDER_ID = 'PROVIDER_ID';
const TOTAL_BOOKING = 'total_booking';
const COMPLETED_BOOKING = 'total_booking';
const CREATED_AT = 'created_at';
const IS_PLAN_SUBSCRIBE = 'IS_PLAN_SUBSCRIBE';
const PLAN_TITLE = 'PLAN_TITLE';
const PLAN_END_DATE = 'PLAN_END_DATE';
const PLAN_IDENTIFIER = 'PLAN_IDENTIFIER';
const PAYMENT_LIST = 'PAYMENT_LIST';
const PRIVACY_POLICY = 'PRIVACY_POLICY';
const TERM_CONDITIONS = 'TERM_CONDITIONS';
const INQUIRY_EMAIL = 'INQUIRY_EMAIL';
const HELPLINE_NUMBER = 'HELPLINE_NUMBER';
const PASSWORD = 'PASSWORD';
const HAS_IN_APP_STORE_REVIEW = 'hasInAppStoreReview1';
const HAS_IN_PLAY_STORE_REVIEW = 'hasInPlayStoreReview1';
const HAS_IN_REVIEW = 'hasInReview';
const SERVER_LANGUAGES = 'SERVER_LANGUAGES';
const HANDYMAN_AVAILABLE_STATUS = 'HANDYMAN_AVAILABLE_STATUS';
const DESIGNATION = 'DESIGNATION';
const UPDATE_NOTIFY = 'UPDATE_NOTIFY';
const CURRENCY_POSITION = 'CURRENCY_POSITION';
const ONLINE = 'Online';
const OFFLINE = 'Offline';
const CASH = 'cash';
const INACTIVE = 'Inactive';
const ACTIVE = 'Active';
const FOR_ALL_SERVICES = 'FOR_ALL_SERVICES';
const SADAD_PAYMENT_ACCESS_TOKEN = 'SADAD_PAYMENT_ACCESS_TOKEN';

const PROVIDER_PLAY_STORE_URL = 'PROVIDER_PLAY_STORE_URL';
const PROVIDER_APPSTORE_URL = 'PROVIDER_APPSTORE_URL';
const CATEGORY_BASED_SELECT_PACKAGE_SERVICE = 'CATEGORY_BASED_SELECT_PACKAGE_SERVICE';

const BOOKING_TYPE_ALL = 'All';
const CATEGORY_TYPE_ALL = 'All';

const ONESIGNAL_APP_ID_PROVIDER = 'ONESIGNAL_ONESIGNAL_APP_ID_PROVIDER';
const ONESIGNAL_REST_API_KEY_PROVIDER = 'ONESIGNAL_ONESIGNAL_REST_API_KEY_PROVIDER';
const ONESIGNAL_CHANNEL_KEY_PROVIDER = 'ONESIGNAL_CHANNEL_KEY_PROVIDER';
//endregion

//region CURRENCY POSITION
const CURRENCY_POSITION_LEFT = 'left';
const CURRENCY_POSITION_RIGHT = 'right';
//endregion

//region FORCE UPDATE
const PROVIDER_CHANGE_LOG = 'providerChangeLog';
//endregion

//region  Login Type
const USER_TYPE_PROVIDER = 'provider';
const USER_TYPE_HANDYMAN = 'handyman';
const USER_STATUS_CODE = 1;
//endregion

//region ProviderType
const PROVIDER_TYPE_FREELANCE = 'freelance';
const PROVIDER_TYPE_COMPANY = 'company';
//endregion

// region Package Type
const PACKAGE_TYPE_SINGLE = 'single';
const PACKAGE_TYPE_MULTIPLE = 'multiple';
//endregion

//region Notification
const MARK_AS_READ = 'markas_read';
const NOTIFICATION_TYPE_BOOKING = 'booking';
const NOTIFICATION_TYPE_POST_JOB = 'post_job';
//endregion

//region SERVICE TYPE

const SERVICE_TYPE_HOURLY = 'hourly';
const SERVICE_TYPE_FIXED = 'fixed';
const SERVICE_TYPE_FREE = 'free';
//endregion

enum GalleryFileTypes { CANCEL, CAMERA, GALLERY }

//region Errors
const USER_NOT_CREATED = "User not created";
const USER_CANNOT_LOGIN = "User can't login";
const USER_NOT_FOUND = "User not found";
//endregion

//region service payment status
const PAID = 'paid';
const PENDING = 'pending';
//endregion

//region ProviderStore
const RESTORE = "restore";
const FORCE_DELETE = "forcedelete";
const type = "type";
//endregion

//region default handyman login
const DEFAULT_PROVIDER_EMAIL = 'demo@provider.com';
const DEFAULT_HANDYMAN_EMAIL = 'demo@handyman.com';
const DEFAULT_PASS = '12345678';
const DEFAULT_PASSWORD_FOR_FIREBASE = '12345678';
//endregion

//region currency
const CURRENCY_COUNTRY_SYMBOL = 'CURRENCY_COUNTRY_SYMBOL';
const CURRENCY_COUNTRY_CODE = 'CURRENCY_COUNTRY_CODE';
const CURRENCY_COUNTRY_ID = 'CURRENCY_COUNTRY_ID';
//endregion

//region Mail And Tel URL
const MAIL_TO = 'mailto:';
const TEL = 'tel:';
//endregion

//region FireBase Collection Name
const MESSAGES_COLLECTION = "messages";
const USER_COLLECTION = "users";
const CONTACT_COLLECTION = "contact";
const CHAT_DATA_IMAGES = "chatImages";

const IS_ENTER_KEY = "IS_ENTER_KEY";
const SELECTED_WALLPAPER = "SELECTED_WALLPAPER";
const SELECT_SUBCATEGORY = "SELECT_SUBCATEGORY";
const SELECT_USER_TYPE = "SELECT_USER_TYPE";
const PER_PAGE_CHAT_COUNT = 50;
const PER_PAGE_CHAT_LIST_COUNT = 10;

const TEXT = "TEXT";
const IMAGE = "IMAGE";

const VIDEO = "VIDEO";
const AUDIO = "AUDIO";
//endregion

//region RTLLanguage
const List<String> RTL_LANGUAGES = ['ar', 'ur'];
//endregion

//region MessageType
enum MessageType {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
}
//endregion

//region MessageExtension
extension MessageExtension on MessageType {
  String? get name {
    switch (this) {
      case MessageType.TEXT:
        return 'TEXT';
      case MessageType.IMAGE:
        return 'IMAGE';
      case MessageType.VIDEO:
        return 'VIDEO';
      case MessageType.AUDIO:
        return 'AUDIO';
      default:
        return null;
    }
  }
}
//endregion

//region SERVICE PAYMENT STATUS
const SERVICE_PAYMENT_STATUS_PAID = 'paid';
const SERVICE_PAYMENT_STATUS_PENDING = 'pending';
//endregion

//region PAYMENT METHOD
const PAYMENT_METHOD_COD = 'cash';
const PAYMENT_METHOD_STRIPE = 'stripe';
const PAYMENT_METHOD_RAZOR = 'razorPay';
const PAYMENT_METHOD_FLUTTER_WAVE = 'flutterwave';
const PAYMENT_METHOD_CINETPAY = 'cinetpay';
const PAYMENT_METHOD_SADAD_PAYMENT = 'sadad';
const PAYMENT_METHOD_PAYPAL = 'paypal';
//endregion

//region DateFormat
const DATE_FORMAT_1 = 'M/d/yyyy hh:mm a';
const DATE_FORMAT_2 = 'd MMM, yyyy';
const DATE_FORMAT_3 = 'hh:mm a';
const DATE_FORMAT_4 = 'dd MMM';
const DATE_FORMAT_5 = 'yyyy';
const DATE_FORMAT_6 = 'd MMMM, yyyy';
const DATE_FORMAT_7 = 'yyyy-MM-dd';
const DATE_FORMAT_8 = 'HH:mm';
//endregion

//region SUBSCRIPTION PAYMENT STATUS
const SUBSCRIPTION_STATUS_ACTIVE = 'active';
const SUBSCRIPTION_STATUS_INACTIVE = 'inactive';
//endregion

//region EARNING TYPE
const EARNING_TYPE = 'EARNING_TYPE';
const EARNING_TYPE_COMMISSION = 'commission';
const EARNING_TYPE_SUBSCRIPTION = 'subscription';
const FREE = 'free';
//endregion

//region WALLET TYPE
const ADD_WALLET = 'add_wallet';
const UPDATE_WALLET = 'update_wallet';
const WALLET_PAYOUT_TRANSFER = 'wallet_payout_transfer';
const PAYOUT = 'payout';

//endregion

const GOOGLE_MAP_PREFIX = 'https://www.google.com/maps/search/?api=1&query=';

List<String> daysList = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
