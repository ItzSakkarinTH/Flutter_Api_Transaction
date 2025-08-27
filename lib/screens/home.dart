import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validate/components/drawer.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'หน้าหลัก',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(),
      body: Obx(() {
        final user = authController.currentUser;
        
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[800]!,
                Colors.blue[600]!,
                Colors.blue[400]!,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView( // ✅ แก้ไข: เพิ่ม scroll ป้องกัน overflow
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decorative circles
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer decorative ring
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                      // Profile Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.blue[100],
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ),
                      // Floating sparkles
                      Positioned(
                        top: 20,
                        right: 30,
                        child: _buildSparkle(12),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 25,
                        child: _buildSparkle(8),
                      ),
                      Positioned(
                        top: 60,
                        left: 15,
                        child: _buildSparkle(10),
                      ),
                      Positioned(
                        bottom: 50,
                        right: 20,
                        child: _buildSparkle(14),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Welcome Text
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Text(
                          'สวัสดี!',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            user?.fullName ?? "ผู้ใช้",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Text(
                          user?.email ?? "",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        
                        const SizedBox(height: 50),
                        
                        // Welcome Message
                        Container(
                          padding: const EdgeInsets.all(32),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 40,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'ยินดีต้อนรับสู่หน้าหลัก!',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'เราดีใจที่ได้พบคุณวันนี้',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Action Button
                        Container(
                          width: 200,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.9),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.snackbar(
                                '❤️ สำเร็จ',
                                'ขอบคุณที่เข้าใช้งาน!',
                                backgroundColor: Colors.white,
                                colorText: Colors.blue[800],
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                                borderRadius: 15,
                                margin: const EdgeInsets.all(20),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.blue[700],
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.waving_hand, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'สวัสดี!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Decorative elements at bottom
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFloatingIcon(Icons.star, Colors.yellow[300]!, -20),
                            const SizedBox(width: 40),
                            _buildFloatingIcon(Icons.favorite, Colors.pink[300]!, 15),
                            const SizedBox(width: 40),
                            _buildFloatingIcon(Icons.lightbulb, Colors.orange[300]!, -10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildFloatingIcon(IconData icon, Color color, double offset) {
    return Transform.translate(
      offset: Offset(0, offset),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.2),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 24,
        ),
      ),
    );
  }
  
  Widget _buildSparkle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: size / 2,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
