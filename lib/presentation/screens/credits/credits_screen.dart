import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/core/constants/app_sizes.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.credits.title,
            style: TextStyle(fontSize: AppSizes.font.titleSmall),
          ),
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            customBorder: const CircleBorder(),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(AppSizes.padding.medium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.credits.author,
                style: TextStyle(fontSize: AppSizes.font.title),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.spacing.large),
              Text(
                AppStrings.credits.tmdbCredits,
                style: TextStyle(fontSize: AppSizes.font.subtitleSmall),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.spacing.smallest),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(AppSizes.padding.smallest),
                child: SvgPicture.asset(
                  'assets/images/logo-tmdb.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
