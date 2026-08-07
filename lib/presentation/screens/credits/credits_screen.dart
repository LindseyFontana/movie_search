import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/core/constants/app_sizes.dart';
import 'package:movie_search/presentation/screens/widgets/back_button_widget.dart';
import 'package:movie_search/presentation/screens/widgets/custom_app_bar.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.credits.title,
          leading: BackButtonWidget(hasShadow: false),
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
