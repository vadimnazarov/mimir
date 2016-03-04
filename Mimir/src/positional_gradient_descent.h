//
// Created by Vadim N. on 04/03/2016.
//

#ifndef MIMIR_POSITIONAL_GRADIENT_DESCENT_H
#define MIMIR_POSITIONAL_GRADIENT_DESCENT_H


#include "model_fitting_algorithm.h"
#include "positional_selection_model.h"


namespace mimir {


    class GradientDescent : public ModelFittingAlgorithm<PositionalSelectionModel> {

    public:

        struct Parameters {
            int max_step;
            double eps;
        };


        void fit(PositionalSelectionModel *model,
                 const Cloneset &exp_data,
                 const Cloneset &gen_data,
                 const Parameters &params) const
        {

        }

    };

}


#endif //MIMIR_POSITIONAL_GRADIENT_DESCENT_H
