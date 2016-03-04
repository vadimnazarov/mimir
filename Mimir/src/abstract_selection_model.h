//
// Created by Vadim N. on 04/03/2016.
//

#ifndef MIMIR_ABSTRACT_SELECTION_MODEL_H
#define MIMIR_ABSTRACT_SELECTION_MODEL_H


#include <vector>
#include <fstream>

#include <Ymir/Graph>


using namespace ymir;


namespace mimir {


    typedef std::string string_t;


    typedef double Qvalue;
    typedef std::vector<Qvalue> QvalueVec;


    typedef JsonValue ModelParameters;


    class AbstractSelectionModel {
    public:

        virtual Qvalue predict(const Clonotype& clonotype) const = 0;

        virtual QvalueVec predict(const Cloneset &cloneset) const {
            QvalueVec res;
            res.reserve(cloneset.size());
            for (size_t i = 0; i < cloneset.size(); ++i) {
                res.push_back(this->predict(cloneset[i]));
            }
            return res;
        }


        bool read(const string_t &filepath) {
            this->make_parameters();

            std::ifstream stream(filepath);
            if (stream.is_open()) {
                /* read JSON here */
                return true;
            }
            return false;
        }


        bool write(const string_t &filepath) {
            this->make_parameters();

            std::ifstream stream(filepath);
            if (stream.is_open()) {
                /* write JSON here */
                return true;
            }
            return false;
        }

        const ModelParameters& parameters() const { return _parameters; }

    protected:

        ModelParameters _parameters;


        /**
         * \brief Make JsonValue parameters from the model-specific internal
         * representation of parameters;
         */
        virtual void make_parameters() = 0;

    };
}


#endif //MIMIR_ABSTRACT_SELECTION_MODEL_H
