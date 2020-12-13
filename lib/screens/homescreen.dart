import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloudy/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloudy/utilities/constants.dart';
import 'package:cloudy/services/weather.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.locationWeather});
  final locationWeather;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherModel weather = WeatherModel();
  int temperature;
  String cityName;
  String weatherIcon;
  String weatherMessage;
  String weatherDes;
  String country;
  String weatherM;
  int humidity;
  double windSpeed;
  int pressure;
  dynamic icon;
  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error!';
        weatherMessage = 'Unable to fetch weather data';
        cityName = '';
        return;
      }
      var temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      cityName = weatherData['name'];

      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);

      var weatherDescription = weatherData['weather'][0]['description'];
      weatherDes = weatherDescription;
      var weatherMain = weatherData['weather'][0]['main'];
      weatherM = weatherMain;

      var countryName = weatherData['sys']['country'];
      country = countryName;
      var hum = weatherData['main']['humidity'];
      humidity = hum;
      var speed = weatherData['wind']['speed'];
      windSpeed = speed;
      var pres = weatherData['main']['pressure'];
      pressure = pres;
      var ic = weatherData['weather'][0]['icon'];
      icon = ic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TopButton(
                    icon: FontAwesomeIcons.locationArrow,
                    text: 'Location',
                    click: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                  ),
                  TopButton(
                    icon: FontAwesomeIcons.city,
                    text: 'City  ',
                    click: () async {
                      var typedName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CityScreen()));
                      if (typedName != null) {
                        var weatherData =
                            await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        weatherM,
                        style: GoogleFonts.architectsDaughter(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Text(
                      '$cityName, $country',
                      style: GoogleFonts.architectsDaughter(
                        fontSize: 30,
                        letterSpacing: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$temperature°',
                          style: GoogleFonts.patrickHand(
                            fontSize: 90,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 10,
                          ),
                        ),
                        Container(
                          child: Image.network(
                              'http://openweathermap.org/img/wn/$icon@2x.png'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                      child: Divider(
                        color: Colors.white,
                        endIndent: 70,
                        indent: 70,
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      //first row
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: TransparentCard(
                                text: 'Pressure',
                                customTextStyle:
                                    kNumberCardTextStyle.copyWith(fontSize: 25),
                                textData: '$pressure mb',
                              ),
                            ),
                            Expanded(
                              child: TransparentCard(
                                text: 'Description',
                                textData: weatherDes,
                                customTextStyle: GoogleFonts.architectsDaughter(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //second row
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: TransparentCard(
                                text: 'Humidity',
                                customTextStyle: kNumberCardTextStyle,
                                textData: '$humidity%',
                              ),
                            ),
                            Expanded(
                              child: TransparentCard(
                                text: 'Wind Speed',
                                customTextStyle:
                                    kNumberCardTextStyle.copyWith(fontSize: 30),
                                textData: '$windSpeed ms',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopButton extends StatelessWidget {
  TopButton({this.icon, this.text, this.click});
  final String text;
  final IconData icon;
  final Function click;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: click,
      child: BlurryContainer(
        borderRadius: BorderRadius.circular(7),
        bgColor: Colors.white,
        blur: 1,
        child: Row(
          children: [
            Icon(
              icon,
            ),
            SizedBox(
              width: 50,
            ),
            Text(
              text,
              style: GoogleFonts.architectsDaughter(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransparentCard extends StatelessWidget {
  TransparentCard({@required this.text, this.textData, this.customTextStyle});
  final String text;
  final String textData;
  final TextStyle customTextStyle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlurryContainer(
        bgColor: Colors.white,
        borderRadius: BorderRadius.circular(6),
        blur: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              text,
              style: kCardTextStyle,
            ),
            SizedBox(
              height: 1,
              child: Divider(
                color: Colors.white,
                thickness: 1.5,
              ),
            ),
            Flexible(
              child: Text(
                textData,
                style: customTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
