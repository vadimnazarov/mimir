//
// Created by Vadim N. on 04/03/2016.
//

#ifndef MIMIR_MODEL_FITTING_ALGORITHM_H
#define MIMIR_MODEL_FITTING_ALGORITHM_H


#include "abstract_selection_model.h"

#include "Ymir/Model"

using namespace ymir;


namespace mimir {

    template <AbstractSelectionModel M>
    class ModelFittingAlgorithm {
    public:

        struct Parameters {
            /* eps, num_iterations, etc. */
        };


        virtual void fit(M *model,
                         const Cloneset &exp_data,
                         const Cloneset &gen_data,
                         const Parameters &params) const = 0;

        void fit(M *model,
                 const Cloneset &exp_data,
                 const ProbabilisticAssemblingModel &model,
                 size_t num_clonotypes_to_generate = 1000000,
                 const Parameters &params) const
        {
            this->fit(M, exp_data, model.generateSequences(num_clonotypes_to_generate), params);
        }

    };

}


#endif //MIMIR_MODEL_FITTING_ALGORITHM_H
