/// Admin dashboard text constants
class AdminTexts {
  AdminTexts._();

  /// App
  static const String appName = 'Trash2Heal Admin';
  static const String appTagline = 'Waste Management Dashboard';

  /// Common Actions
  static const String add = 'Add';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String close = 'Close';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String export = 'Export';
  static const String refresh = 'Refresh';
  static const String view = 'View';
  static const String submit = 'Submit';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String yes = 'Yes';
  static const String no = 'No';

  /// Navigation
  static const String dashboard = 'Dashboard';
  static const String pickupSlots = 'Pickup Slots';
  static const String pickupRates = 'Pickup Rates';
  static const String events = 'Events';
  static const String eventItems = 'Event Items';
  static const String users = 'Users';
  static const String transactions = 'Transactions';
  static const String settings = 'Settings';
  static const String logout = 'Logout';

  /// Auth
  static const String login = 'Login';
  static const String loginTitle = 'Sign in to Admin Dashboard';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String rememberMe = 'Remember me';
  static const String forgotPassword = 'Forgot password?';
  static const String loginSuccess = 'Login successful';
  static const String loginFailed = 'Login failed';
  static const String logoutConfirm = 'Are you sure you want to logout?';
  static const String logoutSuccess = 'Logged out successfully';

  /// Dashboard
  static const String welcome = 'Welcome back';
  static const String overview = 'Overview';
  static const String statistics = 'Statistics';
  static const String recentActivity = 'Recent Activity';
  static const String totalUsers = 'Total Users';
  static const String activePickups = 'Active Pickups';
  static const String pointsDistributed = 'Points Distributed';
  static const String revenue = 'Revenue';
  static const String pickupTrends = 'Pickup Trends';
  static const String revenueTrends = 'Revenue Trends';
  static const String userGrowth = 'User Growth';

  /// Pickup Slots
  static const String addPickupSlot = 'Add Pickup Slot';
  static const String editPickupSlot = 'Edit Pickup Slot';
  static const String deletePickupSlot = 'Delete Pickup Slot';
  static const String slotDate = 'Date';
  static const String startTime = 'Start Time';
  static const String endTime = 'End Time';
  static const String maxCapacity = 'Max Capacity';
  static const String currentBookings = 'Current Bookings';
  static const String slotStatus = 'Status';

  /// Pickup Rates
  static const String addPickupRate = 'Add Pickup Rate';
  static const String editPickupRate = 'Edit Pickup Rate';
  static const String deletePickupRate = 'Delete Pickup Rate';
  static const String wasteType = 'Waste Type';
  static const String pricePerKg = 'Price per KG';
  static const String pointsPerKg = 'Points per KG';
  static const String description = 'Description';

  /// Events
  static const String addEvent = 'Add Event';
  static const String editEvent = 'Edit Event';
  static const String deleteEvent = 'Delete Event';
  static const String eventTitle = 'Event Title';
  static const String eventDescription = 'Event Description';
  static const String startDate = 'Start Date';
  static const String endDate = 'End Date';
  static const String location = 'Location';
  static const String pointsRequired = 'Points Required';
  static const String maxParticipants = 'Max Participants';
  static const String participants = 'Participants';
  static const String eventImage = 'Event Image';

  /// Event Items
  static const String addEventItem = 'Add Event Item';
  static const String editEventItem = 'Edit Event Item';
  static const String deleteEventItem = 'Delete Event Item';
  static const String itemName = 'Item Name';
  static const String itemPoints = 'Points Required';
  static const String itemStock = 'Stock';
  static const String itemImage = 'Item Image';

  /// Users
  static const String userManagement = 'User Management';
  static const String userDetails = 'User Details';
  static const String userName = 'Name';
  static const String userEmail = 'Email';
  static const String userPhone = 'Phone';
  static const String userRole = 'Role';
  static const String userPoints = 'Points';
  static const String userStatus = 'Status';
  static const String joinDate = 'Join Date';
  static const String suspendUser = 'Suspend User';
  static const String activateUser = 'Activate User';
  static const String adjustPoints = 'Adjust Points';

  /// Transactions
  static const String transactionHistory = 'Transaction History';
  static const String transactionId = 'Transaction ID';
  static const String transactionType = 'Type';
  static const String transactionAmount = 'Amount';
  static const String transactionStatus = 'Status';
  static const String transactionDate = 'Date';

  /// Settings
  static const String generalSettings = 'General Settings';
  static const String appSettings = 'App Settings';
  static const String membershipPlans = 'Membership Plans';
  static const String notifications = 'Notifications';
  static const String maintenance = 'Maintenance';
  static const String about = 'About';

  /// Status
  static const String active = 'Active';
  static const String inactive = 'Inactive';
  static const String pending = 'Pending';
  static const String completed = 'Completed';
  static const String cancelled = 'Cancelled';
  static const String processing = 'Processing';
  static const String approved = 'Approved';
  static const String rejected = 'Rejected';
  static const String suspended = 'Suspended';

  /// Messages
  static const String noDataAvailable = 'No data available';
  static const String loadingData = 'Loading data...';
  static const String errorLoadingData = 'Error loading data';
  static const String operationSuccess = 'Operation completed successfully';
  static const String operationFailed = 'Operation failed';
  static const String deleteConfirmation =
      'Are you sure you want to delete this item?';
  static const String deleteSuccess = 'Item deleted successfully';
  static const String deleteFailed = 'Failed to delete item';
  static const String saveSuccess = 'Changes saved successfully';
  static const String saveFailed = 'Failed to save changes';
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Invalid email format';
  static const String invalidNumber = 'Invalid number format';
  static const String invalidDate = 'Invalid date format';

  /// Validation
  static const String fieldRequired = 'This field is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordTooShort =
      'Password must be at least 6 characters';
  static const String numberInvalid = 'Please enter a valid number';
  static const String dateInvalid = 'Please enter a valid date';
  static const String timeInvalid = 'Please enter a valid time';

  /// Confirmation
  static const String confirmDelete = 'Are you sure you want to delete this?';
  static const String confirmSuspend =
      'Are you sure you want to suspend this user?';
  static const String confirmActivate =
      'Are you sure you want to activate this user?';
  static const String confirmLogout = 'Are you sure you want to logout?';
  static const String cannotBeUndone = 'This action cannot be undone.';

  /// Empty States
  static const String noItemsFound = 'No items found';
  static const String noUsersFound = 'No users found';
  static const String noTransactionsFound = 'No transactions found';
  static const String noEventsFound = 'No events found';
  static const String noSlotsFound = 'No slots found';
  static const String noRatesFound = 'No rates found';

  /// Filters
  static const String filterBy = 'Filter by';
  static const String filterByStatus = 'Filter by Status';
  static const String filterByRole = 'Filter by Role';
  static const String filterByDate = 'Filter by Date';
  static const String clearFilters = 'Clear Filters';
  static const String applyFilters = 'Apply Filters';

  /// Export
  static const String exportToCsv = 'Export to CSV';
  static const String exportToExcel = 'Export to Excel';
  static const String exportToPdf = 'Export to PDF';
  static const String print = 'Print';

  /// Pagination
  static const String rowsPerPage = 'Rows per page';
  static const String of = 'of';
  static const String page = 'Page';

  /// Help
  static const String help = 'Help';
  static const String documentation = 'Documentation';
  static const String support = 'Support';
  static const String contactSupport = 'Contact Support';

  /// Footer
  static const String copyright = '© 2024 Trash2Heal. All rights reserved.';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';
}
