import 'package:flutter/material.dart';

class AboutYapisdaCarWash extends StatelessWidget {
  const AboutYapisdaCarWash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Yapisda Car Wash',
          style: TextStyle(
            fontFamily: 'JosefinSansReg',
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Yapisda Car Wash',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'About Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Yapisda Car Wash is a leading car wash company dedicated to providing high-quality car washing and detailing services. With our state-of-the-art facilities and a team of skilled professionals, we ensure that your car receives the best care and attention it deserves.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our Services',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'At Yapisda Car Wash, we offer a wide range of services to meet your car care needs. Our services include:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Exterior Car Wash'),
                  Text('- Interior Cleaning and Vacuuming'),
                  Text('- Waxing and Polishing'),
                  Text('- Tire and Rim Care'),
                  Text('- Engine Bay Cleaning'),
                  Text('- Detailing Services'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Visit Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Come visit our car wash center located at:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Jalan Raya Cisoka - Tigaraksa, Kampung Saga, Desa Caringin, Kecamatan Cisoka, Kabupaten Tangerang, Banten',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
