import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/policies/clinet_model.dart';
import 'policies_state.dart';

class PoliciesCubit extends Cubit<PoliciesState> {
  PoliciesCubit()
      : super(PoliciesState(
          plans: PlansRepository.plans,
          clients: [
            ClientModel(name: 'Sara Mahmoud', planType: 'Quarterly', currentDay: 12),
            ClientModel(name: 'Youssef Ammar', planType: 'Monthly', currentDay: 17),
            ClientModel(name: 'Marwa Salem', planType: 'Monthly', currentDay: 3),
            ClientModel(name: 'Khawla Ali', planType: 'Monthly', currentDay: 18),
            ClientModel(name: 'Hager Ahmed', planType: 'Monthly', currentDay: 22),
            ClientModel(name: 'Kadeja Ahmed', planType: 'Monthly', currentDay: 5),
          ],
        ));

  void updatePrice(PlanModel plan, int newPrice) {
    plan.price = newPrice;
    PlansRepository.savePrice(plan);
    emit(PoliciesState(plans: state.plans, clients: state.clients));
  }

  // نستخدمها لما نرجع من صفحة تفاصيل العميل
  void refresh() {
    emit(PoliciesState(plans: state.plans, clients: state.clients));
  }
}