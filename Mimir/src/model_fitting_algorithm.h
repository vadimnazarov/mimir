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


        void fit(M *model,
                 const ClonesetView &exp_data,
                 const ClonesetView &gen_data,
                 const Parameters &params) const
        {
            ModelParameters mod_pars = this->_fit(exp_data.coding(), gen_data.coding(), params);
            if (model) {
                model->set_parameters(mod_pars);
            } else {
                model = new M(mod_pars);
            }
        }


        void fit(M *model,
                 const ClonesetView &exp_data,
                 const ProbabilisticAssemblingModel &model,
                 size_t num_clonotypes_to_generate = 1000000,
                 const Parameters &params) const
        {
            this->fit(M, exp_data, model.generateSequences(num_clonotypes_to_generate), params);
        }


    protected:

        virtual ModelParameters _fit(const ClonesetView &exp_data,
                                     const ClonesetView &gen_data,
                                     const Parameters &params) const = 0;

    };

}


#endif //MIMIR_MODEL_FITTING_ALGORITHM_H
