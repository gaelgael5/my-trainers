class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Coach Routes
  static const String coachDashboard = '/coach/dashboard';
  static const String coachClients = '/coach/clients';
  static const String coachPrograms = '/coach/programs';
  static const String coachChat = '/coach/chat';
  static const String coachProfile = '/coach/profile';
  static const String coachOnboarding = '/coach/onboarding';

  // Client Routes
  static const String clientDashboard = '/client/dashboard';
  static const String clientSearch = '/client/search';
  static const String clientBookings = '/client/bookings';
  static const String clientChat = '/client/chat';
  static const String clientProfile = '/client/profile';
  static const String clientOnboarding = '/client/onboarding';

  // Shared Routes
  static const String settings = '/settings';
  static const String notifications = '/notifications';

  // Client Detail Routes
  static const String clientDetail = '/coach/clients/:clientId';
  static const String clientPrograms = '/coach/clients/:clientId/programs';
  static const String clientHistory = '/coach/clients/:clientId/history';

  // Program Routes
  static const String programDetail = '/coach/programs/:programId';
  static const String programEdit = '/coach/programs/:programId/edit';
  static const String programCreate = '/coach/programs/create';
  static const String sessionDetail = '/coach/programs/:programId/sessions/:sessionId';

  // Chat Routes
  static const String chatConversation = '/chat/:conversationId';

  // Coach Search Routes (for clients)
  static const String coachDetail = '/coaches/:coachId';
  static const String bookSession = '/coaches/:coachId/book';

  // Payment Routes
  static const String payments = '/payments';
  static const String paymentHistory = '/payments/history';

  // Booking Routes
  static const String bookingDetail = '/bookings/:bookingId';
  static const String bookingConfirmation = '/bookings/:bookingId/confirmation';

  // Profile Setup Routes
  static const String profileStep1 = '/profile/step-1';
  static const String profileStep2 = '/profile/step-2';
  static const String profileStep3 = '/profile/step-3';
  static const String profileStep4 = '/profile/step-4';
  
  // Utility Methods
  static String getClientDetail(String clientId) => '/coach/clients/$clientId';
  static String getClientPrograms(String clientId) => '/coach/clients/$clientId/programs';
  static String getClientHistory(String clientId) => '/coach/clients/$clientId/history';
  
  static String getProgramDetail(String programId) => '/coach/programs/$programId';
  static String getProgramEdit(String programId) => '/coach/programs/$programId/edit';
  static String getSessionDetail(String programId, String sessionId) => 
    '/coach/programs/$programId/sessions/$sessionId';
  
  static String getChatConversation(String conversationId) => '/chat/$conversationId';
  
  static String getCoachDetail(String coachId) => '/coaches/$coachId';
  static String getBookSession(String coachId) => '/coaches/$coachId/book';
  
  static String getBookingDetail(String bookingId) => '/bookings/$bookingId';
  static String getBookingConfirmation(String bookingId) => '/bookings/$bookingId/confirmation';
}